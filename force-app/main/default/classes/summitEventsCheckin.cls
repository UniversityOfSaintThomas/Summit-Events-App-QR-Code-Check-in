/**
 * Created by Thad-PC-2019 on 10/10/2025.
 * Controller for Summit Events QR Code Check-in and Manual Lookup functionality
 */

public with sharing class summitEventsCheckin {

    /**
     * Get total attended count for an instance
     * @param instanceId - The event instance ID
     * @return Integer - Count of registrations marked as Attended
     */
    @AuraEnabled(Cacheable=false)
    public static Integer getTotalAttendedCount(String instanceId) {
        try {
            if (String.isBlank(instanceId)) {
                return 0;
            }

            Integer count = [
                    SELECT COUNT()
                    FROM summit__Summit_Events_Registration__c
                    WHERE summit__Event_Instance__c = :instanceId
                    AND summit__Status__c = 'Attended'
            ];

            return count;
        } catch (Exception e) {
            System.debug('Error getting attended count: ' + e.getMessage());
            return 0;
        }
    }

    /**
     * Get event instances for a given date
     * @param selectedDate - The date to filter instances by
     * @return List<EventInstanceOption> - List of instances occurring on that date
     */
    @AuraEnabled(Cacheable=false)
    public static List<EventInstanceOption> getEventInstancesByDate(Date selectedDate) {
        List<EventInstanceOption> options = new List<EventInstanceOption>();

        try {
            if (selectedDate == null) {
                return options;
            }

            // Query for instances where the date matches
            List<summit__Summit_Events_Instance__c> instances = [
                    SELECT Id, Name, summit__Instance_Title__c,
                            summit__Event__r.Name,
                            summit__Instance_Start_Date__c,
                            summit__Instance_Start_Time__c
                    FROM summit__Summit_Events_Instance__c
                    WHERE summit__Instance_Start_Date__c = :selectedDate
                    ORDER BY summit__Instance_Start_Time__c, summit__Event__r.Name
            ];

            for (summit__Summit_Events_Instance__c instance : instances) {
                EventInstanceOption option = new EventInstanceOption();
                option.value = instance.Id;
                option.label = instance.summit__Event__r.Name + ' - ' + instance.summit__Instance_Title__c;
                option.eventName = instance.summit__Event__r.Name;
                option.instanceTitle = instance.summit__Instance_Title__c;
                options.add(option);
            }

        } catch (Exception e) {
            System.debug('Error getting event instances: ' + e.getMessage());
        }

        return options;
    }

    /**
     * Lookup a registration by QR Code value without checking in
     * @param qrCodeValue - The value from the scanned QR code
     * @param instanceId - The event instance ID to scope the lookup to
     * @return CheckinResult - Result object containing registration details
     */
    @AuraEnabled
    public static CheckinResult lookupRegistrant(String qrCodeValue, String instanceId) {
        CheckinResult result = new CheckinResult();
        System.debug('QR Code Value (Lookup): ' + qrCodeValue);
        System.debug('Instance ID: ' + instanceId);

        try {
            if (String.isBlank(qrCodeValue)) {
                result.success = false;
                result.message = 'QR Code value cannot be empty';
                return result;
            }

            if (String.isBlank(instanceId)) {
                result.success = false;
                result.message = 'Event instance must be selected';
                return result;
            }

            // Query for the registration using the QR Code field and instance
            List<summit__Summit_Events_Registration__c> registrations = [
                    SELECT Id, Name, summit__Status__c,
                            summit__Registrant_First_Name__c,
                            summit__Registrant_Last_Name__c,
                            summit__Event__r.Name,
                            summit__Event_Instance__r.summit__Instance_Title__c,
                            summit__Event_Instance__r.summit__Instance_Start_Date__c,
                            summit__Event_Instance__r.summit__Instance_Start_Time__c
                    FROM summit__Summit_Events_Registration__c
                    WHERE Id = :qrCodeValue
                    AND summit__Event_Instance__c = :instanceId
                    LIMIT 1
            ];

            if (registrations.isEmpty()) {
                result.success = false;
                result.message = 'No registration found with this QR code';
                return result;
            }

            summit__Summit_Events_Registration__c registration = registrations[0];

            // Check if already checked in
            if (registration.summit__Status__c == 'Attended') {
                result.success = true;
                result.alreadyCheckedIn = true;
                result.message = 'This registrant is already checked in';
                result.registrationId = registration.Id;
                result.registrantName = getFullName(registration);
                result.eventName = registration.summit__Event__r.Name;
                result.instanceTitle = registration.summit__Event_Instance__r.summit__Instance_Title__c;
                result.instanceStartDate = registration.summit__Event_Instance__r.summit__Instance_Start_Date__c;
                result.instanceStartTime = registration.summit__Event_Instance__r.summit__Instance_Start_Time__c;
                return result;
            }

            // Return registration details without checking in
            result.success = true;
            result.alreadyCheckedIn = false;
            result.message = 'Registration found';
            result.registrationId = registration.Id;
            result.registrantName = getFullName(registration);
            result.eventName = registration.summit__Event__r.Name;
            result.instanceTitle = registration.summit__Event_Instance__r.summit__Instance_Title__c;
            result.instanceStartDate = registration.summit__Event_Instance__r.summit__Instance_Start_Date__c;
            result.instanceStartTime = registration.summit__Event_Instance__r.summit__Instance_Start_Time__c;

        } catch (Exception e) {
            result.success = false;
            result.message = 'An unexpected error occurred: ' + e.getMessage();
        }

        return result;
    }

    /**
     * Looks up a registration by QR Code value and updates status to Attended
     * @param qrCodeValue - The value from the scanned QR code
     * @param instanceId - The event instance ID to scope the check-in to
     * @return CheckinResult - Result object containing success status and message
     */
    @AuraEnabled
    public static CheckinResult checkInRegistrant(String qrCodeValue, String instanceId) {
        CheckinResult result = new CheckinResult();
        System.debug('QR Code Value: ' + qrCodeValue);
        System.debug('Instance ID: ' + instanceId);

        try {
            if (String.isBlank(qrCodeValue)) {
                result.success = false;
                result.message = 'QR Code value cannot be empty';
                return result;
            }

            if (String.isBlank(instanceId)) {
                result.success = false;
                result.message = 'Event instance must be selected';
                return result;
            }

            // Query for the registration using the QR Code field and instance
            List<summit__Summit_Events_Registration__c> registrations = [
                    SELECT Id, Name, summit__Status__c,
                            summit__Registrant_First_Name__c,
                            summit__Registrant_Last_Name__c,
                            summit__Event__r.Name,
                            summit__Event_Instance__r.summit__Instance_Title__c
                    FROM summit__Summit_Events_Registration__c
                    WHERE Id = :qrCodeValue
                    AND summit__Event_Instance__c = :instanceId
                    LIMIT 1
            ];

            if (registrations.isEmpty()) {
                result.success = false;
                result.message = 'No registration found with this QR code';
                return result;
            }

            summit__Summit_Events_Registration__c registration = registrations[0];

            // Check if already checked in
            if (registration.summit__Status__c == 'Attended') {
                result.success = true;
                result.alreadyCheckedIn = true;
                result.message = 'This registrant is already checked in';
                result.registrationId = registration.Id;
                result.registrantName = getFullName(registration);
                result.eventName = registration.summit__Event__r.Name;
                result.instanceTitle = registration.summit__Event_Instance__r.summit__Instance_Title__c;
                return result;
            }

            // Update status to Attended
            registration.summit__Status__c = 'Attended';
            update registration;

            result.success = true;
            result.alreadyCheckedIn = false;
            result.message = 'Check-in successful!';
            result.registrationId = registration.Id;
            result.registrantName = getFullName(registration);
            result.eventName = registration.summit__Event__r.Name;
            result.instanceTitle = registration.summit__Event_Instance__r.summit__Instance_Title__c;

        } catch (DmlException e) {
            result.success = false;
            result.message = 'Error updating registration: ' + e.getMessage();
        } catch (Exception e) {
            result.success = false;
            result.message = 'An unexpected error occurred: ' + e.getMessage();
        }

        return result;
    }

    /**
     * Undo a check-in by reverting registration status from Attended back to Registered
     * @param registrationId - The ID of the registration to undo
     * @param instanceId - The event instance ID to verify the registration belongs to this instance
     * @return CheckinResult - Result object containing success status and message
     */
    @AuraEnabled
    public static CheckinResult undoCheckIn(String registrationId, String instanceId) {
        CheckinResult result = new CheckinResult();
        System.debug('Undo Check-In for Registration ID: ' + registrationId);
        System.debug('Instance ID: ' + instanceId);

        try {
            if (String.isBlank(registrationId)) {
                result.success = false;
                result.message = 'Registration ID cannot be empty';
                return result;
            }

            if (String.isBlank(instanceId)) {
                result.success = false;
                result.message = 'Event instance must be selected';
                return result;
            }

            // Query for the registration
            List<summit__Summit_Events_Registration__c> registrations = [
                    SELECT Id, Name, summit__Status__c,
                            summit__Registrant_First_Name__c,
                            summit__Registrant_Last_Name__c,
                            summit__Event__r.Name,
                            summit__Event_Instance__r.summit__Instance_Title__c,
                            summit__Event_Instance__r.summit__Instance_Start_Date__c,
                            summit__Event_Instance__r.summit__Instance_Start_Time__c
                    FROM summit__Summit_Events_Registration__c
                    WHERE Id = :registrationId
                    AND summit__Event_Instance__c = :instanceId
                    LIMIT 1
            ];

            if (registrations.isEmpty()) {
                result.success = false;
                result.message = 'Registration not found';
                return result;
            }

            summit__Summit_Events_Registration__c registration = registrations[0];

            // Check if registration is actually checked in
            if (registration.summit__Status__c != 'Attended') {
                result.success = false;
                result.message = 'Registration is not checked in';
                return result;
            }

            // Revert status back to Registered
            registration.summit__Status__c = 'Registered';
            update registration;

            result.success = true;
            result.alreadyCheckedIn = false;
            result.message = 'Check-in successfully undone';
            result.registrationId = registration.Id;
            result.registrantName = getFullName(registration);
            result.eventName = registration.summit__Event__r.Name;
            result.instanceTitle = registration.summit__Event_Instance__r.summit__Instance_Title__c;
            result.instanceStartDate = registration.summit__Event_Instance__r.summit__Instance_Start_Date__c;
            result.instanceStartTime = registration.summit__Event_Instance__r.summit__Instance_Start_Time__c;

        } catch (DmlException e) {
            result.success = false;
            result.message = 'Error updating registration: ' + e.getMessage();
        } catch (Exception e) {
            result.success = false;
            result.message = 'An unexpected error occurred: ' + e.getMessage();
        }

        return result;
    }

    /**
     * Search for registrations by first name, last name, and/or email
     * @param firstName - First name to search for
     * @param lastName - Last name to search for
     * @param email - Email address to search for
     * @param instanceId - The event instance ID to scope the search to
     * @return List<RegistrationSearchResult> - List of matching registrations
     */
    @AuraEnabled(Cacheable=false)
    public static List<RegistrationSearchResult> searchRegistrations(String firstName, String lastName, String email, String instanceId) {
        List<RegistrationSearchResult> results = new List<RegistrationSearchResult>();

        try {
            if (String.isBlank(firstName) && String.isBlank(lastName) && String.isBlank(email)) {
                return results;
            }

            if (String.isBlank(instanceId)) {
                return results;
            }

            String firstNamePattern = String.isBlank(firstName) ? '%' : '%' + firstName + '%';
            String lastNamePattern = String.isBlank(lastName) ? '%' : '%' + lastName + '%';
            String emailPattern = String.isBlank(email) ? '%' : '%' + email + '%';
            String fullNamePattern = '%' + firstName + ' ' + lastName + '%';

            // Query for matching registrations
            List<summit__Summit_Events_Registration__c> registrations = [
                    SELECT Id,
                            Name,
                            summit__Status__c,
                            summit__Registrant_First_Name__c,
                            summit__Registrant_Last_Name__c,
                            summit__Preferred_First_Name_Formatted__c,
                            summit__Registrant_Preferred_First_Name__c,
                            summit__Registrant_Email__c,
                            summit__Event__r.Name,
                            summit__Event_Instance__r.summit__Instance_Title__c,
                            summit__Event_Instance__r.summit__Instance_Start_Date__c
                    FROM summit__Summit_Events_Registration__c
                    WHERE
                            summit__Event_Instance__c = :instanceId
                            AND summit__Status__c != 'Cancelled'

                            AND (
                                    (summit__Registrant_First_Name__c LIKE :firstNamePattern
                                    AND summit__Registrant_Last_Name__c LIKE :lastNamePattern)

                                    OR (summit__Registrant_Preferred_First_Name__c LIKE :firstNamePattern

                                    AND summit__Registrant_Last_Name__c LIKE :lastNamePattern)
                                    OR summit__Preferred_First_Name_Formatted__c LIKE :fullNamePattern
                                    OR summit__Registrant_Email__c LIKE :emailPattern
                            )
                    ORDER BY summit__Event_Instance__r.summit__Instance_Start_Date__c DESC,
                            summit__Registrant_Last_Name__c,
                            summit__Registrant_First_Name__c
                    LIMIT 50
            ];

            for (summit__Summit_Events_Registration__c reg : registrations) {
                RegistrationSearchResult result = new RegistrationSearchResult();
                result.registrationId = reg.Id;
                result.registrantName = getFullName(reg);
                result.email = reg.summit__Registrant_Email__c;
                result.eventName = reg.summit__Event__r.Name;
                result.instanceTitle = reg.summit__Event_Instance__r.summit__Instance_Title__c;
                result.status = reg.summit__Status__c;
                result.isCheckedIn = reg.summit__Status__c == 'Attended';
                results.add(result);
            }

        } catch (Exception e) {
            System.debug('Error searching registrations: ' + e.getMessage());
        }

        return results;
    }

    /**
     * Check in a registrant by registration ID
     * @param registrationId - The Salesforce ID of the registration record
     * @param instanceId - The event instance ID to scope the check-in to
     * @return CheckinResult - Result object containing success status and message
     */
    @AuraEnabled
    public static CheckinResult checkInRegistrantById(String registrationId, String instanceId) {
        CheckinResult result = new CheckinResult();

        try {
            if (String.isBlank(registrationId)) {
                result.success = false;
                result.message = 'Registration ID cannot be empty';
                return result;
            }

            if (String.isBlank(instanceId)) {
                result.success = false;
                result.message = 'Event instance must be selected';
                return result;
            }

            // Query for the registration
            List<summit__Summit_Events_Registration__c> registrations = [
                    SELECT Id, Name, summit__Status__c,
                            summit__Registrant_First_Name__c,
                            summit__Registrant_Last_Name__c,
                            summit__Event__r.Name,
                            summit__Event_Instance__r.summit__Instance_Title__c
                    FROM summit__Summit_Events_Registration__c
                    WHERE Id = :registrationId
                    AND summit__Event_Instance__c = :instanceId
                    LIMIT 1
            ];

            if (registrations.isEmpty()) {
                result.success = false;
                result.message = 'No registration found';
                return result;
            }

            summit__Summit_Events_Registration__c registration = registrations[0];

            // Check if already checked in
            if (registration.summit__Status__c == 'Attended') {
                result.success = true;
                result.alreadyCheckedIn = true;
                result.message = 'This registrant is already checked in';
                result.registrationId = registration.Id;
                result.registrantName = getFullName(registration);
                result.eventName = registration.summit__Event__r.Name;
                result.instanceTitle = registration.summit__Event_Instance__r.summit__Instance_Title__c;
                return result;
            }

            // Update status to Attended
            registration.summit__Status__c = 'Attended';
            update registration;

            result.success = true;
            result.alreadyCheckedIn = false;
            result.message = 'Check-in successful!';
            result.registrationId = registration.Id;
            result.registrantName = getFullName(registration);
            result.eventName = registration.summit__Event__r.Name;
            result.instanceTitle = registration.summit__Event_Instance__r.summit__Instance_Title__c;

        } catch (DmlException e) {
            result.success = false;
            result.message = 'Error updating registration: ' + e.getMessage();
        } catch (Exception e) {
            result.success = false;
            result.message = 'An unexpected error occurred: ' + e.getMessage();
        }

        return result;
    }

    /**
     * Helper method to get full name from registration
     * @param registration - The registration record containing first and last name
     * @return String - The full name of the registrant
     */
    private static String getFullName(summit__Summit_Events_Registration__c registration) {
        String firstName = registration.summit__Registrant_First_Name__c != null ?
                registration.summit__Registrant_First_Name__c : '';
        String lastName = registration.summit__Registrant_Last_Name__c != null ?
                registration.summit__Registrant_Last_Name__c : '';
        return (firstName + ' ' + lastName).trim();
    }

    /**
     * Wrapper class for event instance options
     */
    public class EventInstanceOption {
        @AuraEnabled public String value;
        @AuraEnabled public String label;
        @AuraEnabled public String eventName;
        @AuraEnabled public String instanceTitle;

        public EventInstanceOption() {
            this.value = '';
            this.label = '';
            this.eventName = '';
            this.instanceTitle = '';
        }
    }

    /**
     * Wrapper class for check-in results
     */
    public class CheckinResult {
        @AuraEnabled public Boolean success;
        @AuraEnabled public Boolean alreadyCheckedIn;
        @AuraEnabled public String message;
        @AuraEnabled public String registrationId;
        @AuraEnabled public String registrantName;
        @AuraEnabled public String eventName;
        @AuraEnabled public String instanceTitle;
        @AuraEnabled public Date instanceStartDate;
        @AuraEnabled public Time instanceStartTime;

        public CheckinResult() {
            this.success = false;
            this.alreadyCheckedIn = false;
            this.message = '';
            this.registrationId = '';
            this.registrantName = '';
            this.eventName = '';
            this.instanceTitle = '';
            this.instanceStartDate = null;
            this.instanceStartTime = null;
        }
    }

    /**
     * Wrapper class for registration search results
     */
    public class RegistrationSearchResult {
        @AuraEnabled public String registrationId;
        @AuraEnabled public String registrantName;
        @AuraEnabled public String email;
        @AuraEnabled public String eventName;
        @AuraEnabled public String instanceTitle;
        @AuraEnabled public String status;
        @AuraEnabled public Boolean isCheckedIn;

        public RegistrationSearchResult() {
            this.registrationId = '';
            this.registrantName = '';
            this.email = '';
            this.eventName = '';
            this.instanceTitle = '';
            this.status = '';
            this.isCheckedIn = false;
        }
    }
}

