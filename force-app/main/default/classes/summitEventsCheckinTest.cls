/**
 * Test class for summitEventsCheckin
 */
@IsTest
private class summitEventsCheckinTest {

    @TestSetup
    static void setup() {
        // Create test event
        summit__Summit_Events__c testEvent = new summit__Summit_Events__c(
            Name = 'Test Event',
            summit__Event_Name__c = 'Test Event'
        );
        insert testEvent;

        // Create test event instance
        summit__Summit_Events_Instance__c testInstance = new summit__Summit_Events_Instance__c(
            summit__Event__c = testEvent.Id,
            summit__Instance_Title__c = 'Test Instance',
            summit__Instance_Start_Date__c = Date.today().addDays(1),
            summit__Instance_End_Date__c = Date.today().addDays(1)
        );
        insert testInstance;

        // Create test registration - QR code will be auto-generated
        summit__Summit_Events_Registration__c testRegistration = new summit__Summit_Events_Registration__c(
            summit__Event__c = testEvent.Id,
            summit__Event_Instance__c = testInstance.Id,
            summit__Registrant_First_Name__c = 'John',
            summit__Registrant_Last_Name__c = 'Doe',
            summit__Registrant_Email__c = 'john.doe@test.com',
            summit__Status__c = 'Registered'
        );
        insert testRegistration;

        // Create another registration that's already attended
        summit__Summit_Events_Registration__c attendedRegistration = new summit__Summit_Events_Registration__c(
            summit__Event__c = testEvent.Id,
            summit__Event_Instance__c = testInstance.Id,
            summit__Registrant_First_Name__c = 'Jane',
            summit__Registrant_Last_Name__c = 'Smith',
            summit__Registrant_Email__c = 'jane.smith@test.com',
            summit__Status__c = 'Attended'
        );
        insert attendedRegistration;
    }

    @IsTest
    static void testSuccessfulCheckin() {
        // Query the auto-generated QR code and instance
        summit__Summit_Events_Registration__c reg = [
            SELECT Id, summit__Event_Instance__c
            FROM summit__Summit_Events_Registration__c
            WHERE summit__Registrant_Email__c = 'john.doe@test.com'
            LIMIT 1
        ];

        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrant(reg.Id, reg.summit__Event_Instance__c);
        Test.stopTest();

        System.assertEquals(true, result.success, 'Check-in should be successful');
        System.assertEquals(false, result.alreadyCheckedIn, 'Should not be already checked in');
        System.assertEquals('Check-in successful!', result.message);
        System.assertEquals('John Doe', result.registrantName);
        System.assertNotEquals(null, result.registrationId, 'Registration ID should be populated');

        // Verify the status was updated
        summit__Summit_Events_Registration__c updatedReg = [
            SELECT summit__Status__c
            FROM summit__Summit_Events_Registration__c
            WHERE Id = :reg.Id
        ];
        System.assertEquals('Attended', updatedReg.summit__Status__c);
    }

    @IsTest
    static void testAlreadyCheckedIn() {
        // Query the registration and instance
        summit__Summit_Events_Registration__c reg = [
            SELECT Id, summit__Event_Instance__c
            FROM summit__Summit_Events_Registration__c
            WHERE summit__Registrant_Email__c = 'jane.smith@test.com'
            LIMIT 1
        ];

        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrant(reg.Id, reg.summit__Event_Instance__c);
        Test.stopTest();

        System.assertEquals(true, result.success, 'Should return success');
        System.assertEquals(true, result.alreadyCheckedIn, 'Should be already checked in');
        System.assertEquals('This registrant is already checked in', result.message);
        System.assertEquals('Jane Smith', result.registrantName);
    }

    @IsTest
    static void testInvalidQRCode() {
        summit__Summit_Events_Instance__c instance = [
            SELECT Id FROM summit__Summit_Events_Instance__c LIMIT 1
        ];

        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrant('001000000000000', instance.Id);
        Test.stopTest();

        System.assertEquals(false, result.success, 'Check-in should fail');
        System.assertEquals('No registration found with this QR code', result.message);
    }

    @IsTest
    static void testEmptyQRCode() {
        summit__Summit_Events_Instance__c instance = [
            SELECT Id FROM summit__Summit_Events_Instance__c LIMIT 1
        ];

        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrant('', instance.Id);
        Test.stopTest();

        System.assertEquals(false, result.success, 'Check-in should fail');
        System.assertEquals('QR Code value cannot be empty', result.message);
    }

    @IsTest
    static void testNullQRCode() {
        summit__Summit_Events_Instance__c instance = [
            SELECT Id FROM summit__Summit_Events_Instance__c LIMIT 1
        ];

        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrant(null, instance.Id);
        Test.stopTest();

        System.assertEquals(false, result.success, 'Check-in should fail');
        System.assertEquals('QR Code value cannot be empty', result.message);
    }

    @IsTest
    static void testSearchRegistrations() {
        summit__Summit_Events_Instance__c instance = [
            SELECT Id FROM summit__Summit_Events_Instance__c LIMIT 1
        ];

        Test.startTest();
        List<summitEventsCheckin.RegistrationSearchResult> results =
            summitEventsCheckin.searchRegistrations('John', 'Doe', '', instance.Id);
        Test.stopTest();

        System.assertNotEquals(0, results.size(), 'Should find at least one registration');
        System.assertEquals('John Doe', results[0].registrantName);
        System.assertEquals('john.doe@test.com', results[0].email);
        System.assertEquals('Test Event', results[0].eventName);
        System.assertEquals('Registered', results[0].status);
        System.assertEquals(false, results[0].isCheckedIn);
    }

    @IsTest
    static void testSearchRegistrationsByFirstNameOnly() {
        summit__Summit_Events_Instance__c instance = [
            SELECT Id FROM summit__Summit_Events_Instance__c LIMIT 1
        ];

        Test.startTest();
        List<summitEventsCheckin.RegistrationSearchResult> results =
            summitEventsCheckin.searchRegistrations('Jane', '', '', instance.Id);
        Test.stopTest();

        System.assertNotEquals(0, results.size(), 'Should find at least one registration');
        System.assertEquals('Jane Smith', results[0].registrantName);
    }

    @IsTest
    static void testSearchRegistrationsByLastNameOnly() {
        summit__Summit_Events_Instance__c instance = [
            SELECT Id FROM summit__Summit_Events_Instance__c LIMIT 1
        ];

        Test.startTest();
        List<summitEventsCheckin.RegistrationSearchResult> results =
            summitEventsCheckin.searchRegistrations('', 'Smith', '', instance.Id);
        Test.stopTest();

        System.assertNotEquals(0, results.size(), 'Should find at least one registration');
        System.assertEquals('Jane Smith', results[0].registrantName);
    }

    @IsTest
    static void testSearchRegistrationsNoResults() {
        summit__Summit_Events_Instance__c instance = [
            SELECT Id FROM summit__Summit_Events_Instance__c LIMIT 1
        ];

        Test.startTest();
        List<summitEventsCheckin.RegistrationSearchResult> results =
            summitEventsCheckin.searchRegistrations('NonExistent', 'Person', '', instance.Id);
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Should not find any registrations');
    }

    @IsTest
    static void testSearchRegistrationsEmptyInput() {
        summit__Summit_Events_Instance__c instance = [
            SELECT Id FROM summit__Summit_Events_Instance__c LIMIT 1
        ];

        Test.startTest();
        List<summitEventsCheckin.RegistrationSearchResult> results =
            summitEventsCheckin.searchRegistrations('', '', '', instance.Id);
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Should return empty list for empty input');
    }

    @IsTest
    static void testSearchRegistrationsByEmail() {
        summit__Summit_Events_Instance__c instance = [
            SELECT Id FROM summit__Summit_Events_Instance__c LIMIT 1
        ];

        Test.startTest();
        List<summitEventsCheckin.RegistrationSearchResult> results =
            summitEventsCheckin.searchRegistrations('', '', 'john.doe@test.com', instance.Id);
        Test.stopTest();

        System.assertNotEquals(0, results.size(), 'Should find at least one registration');
        System.assertEquals('John Doe', results[0].registrantName);
        System.assertEquals('john.doe@test.com', results[0].email);
    }

    @IsTest
    static void testCheckInRegistrantById() {
        summit__Summit_Events_Registration__c reg = [
            SELECT Id, summit__Event_Instance__c
            FROM summit__Summit_Events_Registration__c
            WHERE summit__Registrant_Email__c = 'john.doe@test.com'
            LIMIT 1
        ];

        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrantById(reg.Id, reg.summit__Event_Instance__c);
        Test.stopTest();

        System.assertEquals(true, result.success, 'Check-in should be successful');
        System.assertEquals(false, result.alreadyCheckedIn, 'Should not be already checked in');
        System.assertEquals('Check-in successful!', result.message);
        System.assertEquals('John Doe', result.registrantName);

        // Verify the status was updated
        summit__Summit_Events_Registration__c updatedReg = [
            SELECT summit__Status__c
            FROM summit__Summit_Events_Registration__c
            WHERE Id = :reg.Id
        ];
        System.assertEquals('Attended', updatedReg.summit__Status__c);
    }

    @IsTest
    static void testCheckInRegistrantByIdAlreadyCheckedIn() {
        summit__Summit_Events_Registration__c reg = [
            SELECT Id, summit__Event_Instance__c
            FROM summit__Summit_Events_Registration__c
            WHERE summit__Registrant_Email__c = 'jane.smith@test.com'
            LIMIT 1
        ];

        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrantById(reg.Id, reg.summit__Event_Instance__c);
        Test.stopTest();

        System.assertEquals(true, result.success, 'Should return success');
        System.assertEquals(true, result.alreadyCheckedIn, 'Should be already checked in');
        System.assertEquals('This registrant is already checked in', result.message);
    }

    @IsTest
    static void testCheckInRegistrantByIdInvalid() {
        summit__Summit_Events_Instance__c instance = [
            SELECT Id FROM summit__Summit_Events_Instance__c LIMIT 1
        ];

        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrantById('001000000000000', instance.Id);
        Test.stopTest();

        System.assertEquals(false, result.success, 'Check-in should fail');
        System.assertEquals('No registration found', result.message);
    }

    @IsTest
    static void testCheckInRegistrantByIdEmpty() {
        summit__Summit_Events_Instance__c instance = [
            SELECT Id FROM summit__Summit_Events_Instance__c LIMIT 1
        ];

        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrantById('', instance.Id);
        Test.stopTest();

        System.assertEquals(false, result.success, 'Check-in should fail');
        System.assertEquals('Registration ID cannot be empty', result.message);
    }

    @IsTest
    static void testGetEventInstancesByDate() {
        summit__Summit_Events_Instance__c instance = [
            SELECT Id, summit__Instance_Start_Date__c
            FROM summit__Summit_Events_Instance__c
            LIMIT 1
        ];

        Test.startTest();
        List<summitEventsCheckin.EventInstanceOption> options =
            summitEventsCheckin.getEventInstancesByDate(instance.summit__Instance_Start_Date__c);
        Test.stopTest();

        System.assertNotEquals(0, options.size(), 'Should find at least one instance');
        System.assertEquals(instance.Id, options[0].value);
        System.assert(options[0].label.contains('Test Event'), 'Label should contain event name');
        System.assert(options[0].label.contains('Test Instance'), 'Label should contain instance title');
    }

    @IsTest
    static void testGetEventInstancesByDateNoResults() {
        Test.startTest();
        List<summitEventsCheckin.EventInstanceOption> options =
            summitEventsCheckin.getEventInstancesByDate(Date.today().addDays(100));
        Test.stopTest();

        System.assertEquals(0, options.size(), 'Should not find any instances');
    }

    @IsTest
    static void testGetEventInstancesByDateNull() {
        Test.startTest();
        List<summitEventsCheckin.EventInstanceOption> options =
            summitEventsCheckin.getEventInstancesByDate(null);
        Test.stopTest();

        System.assertEquals(0, options.size(), 'Should return empty list for null date');
    }

    @IsTest
    static void testCheckInWithWrongInstance() {
        // Create a second instance for a different date
        summit__Summit_Events__c testEvent = [SELECT Id FROM summit__Summit_Events__c LIMIT 1];
        summit__Summit_Events_Instance__c secondInstance = new summit__Summit_Events_Instance__c(
            summit__Event__c = testEvent.Id,
            summit__Instance_Title__c = 'Different Instance',
            summit__Instance_Start_Date__c = Date.today().addDays(7),
            summit__Instance_End_Date__c = Date.today().addDays(7)
        );
        insert secondInstance;

        // Get registration from first instance
        summit__Summit_Events_Registration__c reg = [
            SELECT Id, summit__Event_Instance__c
            FROM summit__Summit_Events_Registration__c
            WHERE summit__Registrant_Email__c = 'john.doe@test.com'
            LIMIT 1
        ];

        Test.startTest();
        // Try to check in with wrong instance ID
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrant(reg.Id, secondInstance.Id);
        Test.stopTest();

        System.assertEquals(false, result.success, 'Check-in should fail with wrong instance');
        System.assertEquals('No registration found with this QR code', result.message);
    }

    @IsTest
    static void testCheckInMissingInstance() {
        summit__Summit_Events_Registration__c reg = [
            SELECT Id
            FROM summit__Summit_Events_Registration__c
            WHERE summit__Registrant_Email__c = 'john.doe@test.com'
            LIMIT 1
        ];

        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrant(reg.Id, null);
        Test.stopTest();

        System.assertEquals(false, result.success, 'Check-in should fail without instance');
        System.assertEquals('Event instance must be selected', result.message);
    }
}

