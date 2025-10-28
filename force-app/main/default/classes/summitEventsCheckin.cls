/**
 * Created by Thad-PC-2019 on 10/10/2025.
 * Controller for Summit Events QR Code Check-in functionality
 */

public with sharing class summitEventsCheckin {

    /**
     * Looks up a registration by QR Code value and updates status to Attended
     * @param qrCodeValue - The value from the scanned QR code
     * @return CheckinResult - Result object containing success status and message
     */
    @AuraEnabled
    public static CheckinResult checkInRegistrant(String qrCodeValue) {

        CheckinResult result = new CheckinResult();
        System.debug('QR Code Value: ' + qrCodeValue);

        try {
            if (String.isBlank(qrCodeValue)) {
                result.success = false;
                result.message = 'QR Code value cannot be empty';
                return result;
            }

            // Query for the registration using the QR Code field
            List<summit__Summit_Events_Registration__c> registrations = [
                SELECT Id, Name, summit__Status__c,
                       summit__Registrant_First_Name__c,
                       summit__Registrant_Last_Name__c,
                       summit__Event__r.Name,
                       summit__Event_Instance__r.summit__Instance_Title__c
                FROM summit__Summit_Events_Registration__c
                WHERE Id = :qrCodeValue
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

        public CheckinResult() {
            this.success = false;
            this.alreadyCheckedIn = false;
            this.message = '';
            this.registrationId = '';
            this.registrantName = '';
            this.eventName = '';
            this.instanceTitle = '';
        }
    }
}