/**
 * Quick Test Script for Summit Events QR Check-In
 *
 * HOW TO USE:
 * 1. Open Developer Console
 * 2. File → Open Execute Anonymous Window
 * 3. Copy and paste this code
 * 4. Click "Execute"
 * 5. Check debug logs for test QR code
 * 6. Use the QR code to test the component
 */

// Clean up any existing test data (optional)
/*
List<summit__Summit_Events_Registration__c> existingRegs = [
    SELECT Id FROM summit__Summit_Events_Registration__c
    WHERE summit__Registrant_Email__c LIKE '%test-checkin%'
];
delete existingRegs;
*/

// Create Test Event
summit__Summit_Events__c testEvent = new summit__Summit_Events__c(
    Name = 'QR Check-In Test Event',
    summit__Event_Name__c = 'QR Check-In Test Event',
    summit__Event_Status__c = 'Active'
);
insert testEvent;
System.debug('✅ Created Event: ' + testEvent.Name);

// Create Test Event Instance
summit__Summit_Events_Instance__c testInstance = new summit__Summit_Events_Instance__c(
    summit__Event__c = testEvent.Id,
    summit__Instance_Title__c = 'Test Session - ' + DateTime.now().format('MM/dd HH:mm'),
    summit__Instance_Start_Date__c = Date.today(),
    summit__Instance_End_Date__c = Date.today(),
    summit__Instance_Start_Time__c = '09:00',
    summit__Instance_End_Time__c = '17:00',
    summit__Active_Status__c = 'Active'
);
insert testInstance;
System.debug('✅ Created Instance: ' + testInstance.summit__Instance_Title__c);

// Create Test Registrations
List<summit__Summit_Events_Registration__c> testRegistrations = new List<summit__Summit_Events_Registration__c>();

// Registration 1 - Ready to check in
testRegistrations.add(new summit__Summit_Events_Registration__c(
    summit__Event__c = testEvent.Id,
    summit__Event_Instance__c = testInstance.Id,
    summit__Registrant_First_Name__c = 'Alice',
    summit__Registrant_Last_Name__c = 'Johnson',
    summit__Registrant_Email__c = 'alice.johnson@test-checkin.com',
    summit__Registrant_Id_QR_Code__c = 'QR-ALICE-001',
    summit__Status__c = 'Registered'
));

// Registration 2 - Ready to check in
testRegistrations.add(new summit__Summit_Events_Registration__c(
    summit__Event__c = testEvent.Id,
    summit__Event_Instance__c = testInstance.Id,
    summit__Registrant_First_Name__c = 'Bob',
    summit__Registrant_Last_Name__c = 'Smith',
    summit__Registrant_Email__c = 'bob.smith@test-checkin.com',
    summit__Registrant_Id_QR_Code__c = 'QR-BOB-002',
    summit__Status__c = 'Registered'
));

// Registration 3 - Already checked in
testRegistrations.add(new summit__Summit_Events_Registration__c(
    summit__Event__c = testEvent.Id,
    summit__Event_Instance__c = testInstance.Id,
    summit__Registrant_First_Name__c = 'Charlie',
    summit__Registrant_Last_Name__c = 'Williams',
    summit__Registrant_Email__c = 'charlie.williams@test-checkin.com',
    summit__Registrant_Id_QR_Code__c = 'QR-CHARLIE-003',
    summit__Status__c = 'Attended'
));

// Registration 4 - Ready to check in
testRegistrations.add(new summit__Summit_Events_Registration__c(
    summit__Event__c = testEvent.Id,
    summit__Event_Instance__c = testInstance.Id,
    summit__Registrant_First_Name__c = 'Diana',
    summit__Registrant_Last_Name__c = 'Martinez',
    summit__Registrant_Email__c = 'diana.martinez@test-checkin.com',
    summit__Registrant_Id_QR_Code__c = 'QR-DIANA-004',
    summit__Status__c = 'Registered'
));

insert testRegistrations;
System.debug('✅ Created ' + testRegistrations.size() + ' test registrations');

// Print QR Codes for Testing
System.debug('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
System.debug('📋 TEST QR CODES - Use these to test check-in:');
System.debug('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
System.debug('1. Alice Johnson (Registered): QR-ALICE-001');
System.debug('2. Bob Smith (Registered): QR-BOB-002');
System.debug('3. Charlie Williams (Already Attended): QR-CHARLIE-003');
System.debug('4. Diana Martinez (Registered): QR-DIANA-004');
System.debug('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

// Test the Apex method directly
System.debug('\n🧪 TESTING APEX METHOD DIRECTLY:\n');

// Test 1: Valid check-in
summitEventsCheckin.CheckinResult result1 = summitEventsCheckin.checkInRegistrant('QR-ALICE-001');
System.debug('Test 1 - Valid Check-in:');
System.debug('  Success: ' + result1.success);
System.debug('  Message: ' + result1.message);
System.debug('  Name: ' + result1.registrantName);

// Test 2: Already checked in
summitEventsCheckin.CheckinResult result2 = summitEventsCheckin.checkInRegistrant('QR-CHARLIE-003');
System.debug('\nTest 2 - Already Checked In:');
System.debug('  Success: ' + result2.success);
System.debug('  Already Checked In: ' + result2.alreadyCheckedIn);
System.debug('  Message: ' + result2.message);

// Test 3: Invalid QR code
summitEventsCheckin.CheckinResult result3 = summitEventsCheckin.checkInRegistrant('INVALID-QR-999');
System.debug('\nTest 3 - Invalid QR Code:');
System.debug('  Success: ' + result3.success);
System.debug('  Message: ' + result3.message);

System.debug('\n✅ All tests completed! Use the QR codes above in your component.');

// Clean up function (uncomment to run cleanup)
/*
System.debug('\n🧹 CLEANUP INSTRUCTIONS:');
System.debug('To remove test data, run this:');
System.debug('delete [SELECT Id FROM summit__Summit_Events_Registration__c WHERE summit__Registrant_Email__c LIKE \'%test-checkin%\'];');
System.debug('delete [SELECT Id FROM summit__Summit_Events_Instance__c WHERE summit__Instance_Title__c LIKE \'%Test Session%\'];');
System.debug('delete [SELECT Id FROM summit__Summit_Events__c WHERE Name = \'QR Check-In Test Event\'];');
*/

