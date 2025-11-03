/**
 * Created by Thad-PC-2019 on 10/10/2025.
 * Controller for Summit Events QR Code Check-in and Manual Lookup functionality
 */

public with sharing class summitEventsCheckin {

    /**
     * Get total attended count for an instance
     * @param instanceId - The event instance ID
     * @param checkinStatus - The status value to count (defaults to 'Attended' if blank)
     * @return Integer - Count of registrations marked with the specified status
     */
    @AuraEnabled(Cacheable=false)
    public static Integer getTotalAttendedCount(String instanceId, String checkinStatus) {
        try {
            if (String.isBlank(instanceId)) {
                return 0;
            }

            // Default to 'Attended' if no status provided
            String statusToCount = String.isBlank(checkinStatus) ? 'Attended' : checkinStatus;

            Integer count = [
                    SELECT COUNT()
                    FROM summit__Summit_Events_Registration__c
                    WHERE summit__Event_Instance__c = :instanceId
                    AND summit__Status__c = :statusToCount
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
                option.instanceStartDate = instance.summit__Instance_Start_Date__c;
                option.instanceStartTime = instance.summit__Instance_Start_Time__c;
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
     * @param checkinStatus - The status value to check for (defaults to 'Attended' if blank)
     * @return CheckinResult - Result object containing registration details
     */
    @AuraEnabled
    public static CheckinResult lookupRegistrant(String qrCodeValue, String instanceId, String checkinStatus) {
        CheckinResult result = new CheckinResult();
        System.debug('QR Code Value (Lookup): ' + qrCodeValue);
        System.debug('Instance ID: ' + instanceId);

        // Default to 'Attended' if no status provided
        String statusToCheck = String.isBlank(checkinStatus) ? 'Attended' : checkinStatus;

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

            // Check if already checked in with the specified status
            if (registration.summit__Status__c == statusToCheck) {
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
     * Looks up a registration by QR Code value and updates status to specified value
     * @param qrCodeValue - The value from the scanned QR code
     * @param instanceId - The event instance ID to scope the check-in to
     * @param checkinStatus - The status value to set (defaults to 'Attended' if blank)
     * @return CheckinResult - Result object containing success status and message
     */
    @AuraEnabled
    public static CheckinResult checkInRegistrant(String qrCodeValue, String instanceId, String checkinStatus) {
        CheckinResult result = new CheckinResult();
        System.debug('QR Code Value: ' + qrCodeValue);
        System.debug('Instance ID: ' + instanceId);

        // Default to 'Attended' if no status provided
        String statusToSet = String.isBlank(checkinStatus) ? 'Attended' : checkinStatus;
        System.debug('Check-in Status: ' + statusToSet);

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

            // Check if already checked in with the specified status
            if (registration.summit__Status__c == statusToSet) {
                result.success = true;
                result.alreadyCheckedIn = true;
                result.message = 'This registrant is already checked in';
                result.registrationId = registration.Id;
                result.registrantName = getFullName(registration);
                result.eventName = registration.summit__Event__r.Name;
                result.instanceTitle = registration.summit__Event_Instance__r.summit__Instance_Title__c;
                return result;
            }

            // Update status to the configured value
            registration.summit__Status__c = statusToSet;
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
     * Undo a check-in by reverting registration status from specified checked-in status back to Registered
     * @param registrationId - The ID of the registration to undo
     * @param instanceId - The event instance ID to verify the registration belongs to this instance
     * @param checkinStatus - The status value to check for (defaults to 'Attended' if blank)
     * @return CheckinResult - Result object containing success status and message
     */
    @AuraEnabled
    public static CheckinResult undoCheckIn(String registrationId, String instanceId, String checkinStatus) {
        CheckinResult result = new CheckinResult();
        System.debug('Undo Check-In for Registration ID: ' + registrationId);
        System.debug('Instance ID: ' + instanceId);

        // Default to 'Attended' if no status provided
        String statusToCheck = String.isBlank(checkinStatus) ? 'Attended' : checkinStatus;

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

            // Check if registration is actually checked in with the specified status
            if (registration.summit__Status__c != statusToCheck) {
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
     * @param checkinStatus - The status value to consider as "checked in" (defaults to 'Attended' if blank)
     * @return List<RegistrationSearchResult> - List of matching registrations
     */
    @AuraEnabled(Cacheable=false)
    public static List<RegistrationSearchResult> searchRegistrations(String firstName, String lastName, String email, String instanceId, String checkinStatus) {
        List<RegistrationSearchResult> results = new List<RegistrationSearchResult>();

        // Default to 'Attended' if no status provided
        String statusToCheck = String.isBlank(checkinStatus) ? 'Attended' : checkinStatus;

        try {
            if (String.isBlank(firstName) && String.isBlank(lastName) && String.isBlank(email)) {
                return results;
            }

            if (String.isBlank(instanceId)) {
                return results;
            }

            // Declare pattern variables for query binding
            String firstNamePattern = '';
            String lastNamePattern = '';
            String fullNamePattern = '';

            // Build dynamic query conditions
            String query = 'SELECT Id, Name, summit__Status__c, ' +
                    'summit__Registrant_First_Name__c, summit__Registrant_Last_Name__c, ' +
                    'summit__Preferred_First_Name_Formatted__c, summit__Registrant_Preferred_First_Name__c, ' +
                    'summit__Registrant_Email__c, summit__Event__r.Name, ' +
                    'summit__Event_Instance__r.summit__Instance_Title__c, ' +
                    'summit__Event_Instance__r.summit__Instance_Start_Date__c ' +
                    'FROM summit__Summit_Events_Registration__c ' +
                    'WHERE summit__Event_Instance__c = :instanceId ' +
                    'AND summit__Status__c != \'Cancelled\' ' +
                    'AND summit__Status__c != \'Started\' ';

            // Build search conditions only for provided fields
            List<String> conditions = new List<String>();

            if (!String.isBlank(firstName)) {
                firstNamePattern = '%' + firstName + '%';
                conditions.add('summit__Registrant_First_Name__c LIKE :firstNamePattern');
                conditions.add('summit__Registrant_Preferred_First_Name__c LIKE :firstNamePattern');
            }

            if (!String.isBlank(lastName)) {
                lastNamePattern = '%' + lastName + '%';
                conditions.add('summit__Registrant_Last_Name__c LIKE :lastNamePattern');
            }

            if (!String.isBlank(firstName) && !String.isBlank(lastName)) {
                fullNamePattern = '%' + firstName + ' ' + lastName + '%';
                conditions.add('summit__Preferred_First_Name_Formatted__c LIKE :fullNamePattern');
            }

            if (!String.isBlank(email)) {
                conditions.add('summit__Registrant_Email__c = :email');
            }

            // Add conditions to query if any exist
            if (!conditions.isEmpty()) {
                query += 'AND (' + String.join(conditions, ' OR ') + ') ';
            }

            query += 'ORDER BY summit__Event_Instance__r.summit__Instance_Start_Date__c DESC, ' +
                    'summit__Registrant_Last_Name__c, summit__Registrant_First_Name__c ' +
                    'LIMIT 50';

            List<summit__Summit_Events_Registration__c> registrations = Database.query(query);

            for (summit__Summit_Events_Registration__c reg : registrations) {
                RegistrationSearchResult result = new RegistrationSearchResult();
                result.registrationId = reg.Id;
                result.registrantName = getFullName(reg);
                result.email = reg.summit__Registrant_Email__c;
                result.eventName = reg.summit__Event__r.Name;
                result.instanceTitle = reg.summit__Event_Instance__r.summit__Instance_Title__c;
                result.status = reg.summit__Status__c;
                result.isCheckedIn = reg.summit__Status__c == statusToCheck;
                results.add(result);
            }

        } catch (Exception e) {
            System.debug('Error searching registrations: ' + e.getMessage());
        }

        return results;
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
        @AuraEnabled public Date instanceStartDate;
        @AuraEnabled public Time instanceStartTime;

        public EventInstanceOption() {
            this.value = '';
            this.label = '';
            this.eventName = '';
            this.instanceTitle = '';
            this.instanceStartDate = null;
            this.instanceStartTime = null;
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

