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
        // Query the auto-generated QR code
        summit__Summit_Events_Registration__c reg = [
            SELECT summit__Registrant_Id_QR_Code__c
            FROM summit__Summit_Events_Registration__c
            WHERE summit__Registrant_Email__c = 'john.doe@test.com'
            LIMIT 1
        ];

        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrant(reg.summit__Registrant_Id_QR_Code__c);
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
        // Query the auto-generated QR code
        summit__Summit_Events_Registration__c reg = [
            SELECT summit__Registrant_Id_QR_Code__c
            FROM summit__Summit_Events_Registration__c
            WHERE summit__Registrant_Email__c = 'jane.smith@test.com'
            LIMIT 1
        ];

        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrant(reg.summit__Registrant_Id_QR_Code__c);
        Test.stopTest();

        System.assertEquals(true, result.success, 'Should return success');
        System.assertEquals(true, result.alreadyCheckedIn, 'Should be already checked in');
        System.assertEquals('This registrant is already checked in', result.message);
        System.assertEquals('Jane Smith', result.registrantName);
    }

    @IsTest
    static void testInvalidQRCode() {
        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrant('INVALID-QR-CODE');
        Test.stopTest();

        System.assertEquals(false, result.success, 'Check-in should fail');
        System.assertEquals('No registration found with this QR code', result.message);
    }

    @IsTest
    static void testEmptyQRCode() {
        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrant('');
        Test.stopTest();

        System.assertEquals(false, result.success, 'Check-in should fail');
        System.assertEquals('QR Code value cannot be empty', result.message);
    }

    @IsTest
    static void testNullQRCode() {
        Test.startTest();
        summitEventsCheckin.CheckinResult result =
            summitEventsCheckin.checkInRegistrant(null);
        Test.stopTest();

        System.assertEquals(false, result.success, 'Check-in should fail');
        System.assertEquals('QR Code value cannot be empty', result.message);
    }
}

