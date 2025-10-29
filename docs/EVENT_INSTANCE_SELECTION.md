# Event Instance Selection Feature

## Overview

The check-in component now requires users to select a specific event instance before starting a scanning session. This ensures that check-ins are scoped to the correct event and prevents accidental cross-event check-ins.

---

## How It Works

### 1. Date Selection
- Users first select the date of the event they're checking in for
- The date picker appears on the initial "Start Scanning Session" screen
- Required field - must be filled before proceeding

### 2. Instance Selection
- After selecting a date, the component queries for all active Summit Event Instances on that date
- A dropdown/picklist appears showing available instances
- Each option displays: `Event Name - Instance Title`
- Required field - must be selected before starting session

### 3. Session Scoping
- Once an instance is selected and session started, the instance ID is stored
- All subsequent operations (QR scanning, manual lookup, check-ins) are scoped to that instance
- This prevents checking in registrants to the wrong event

---

## User Experience

### Initial Screen
```
┌─────────────────────────────────────┐
│  Ready to Check In Registrants      │
│                                     │
│  Select the event date and instance │
│  to begin checking in attendees.   │
│                                     │
│  Event Date: [____/____/____]      │
│                                     │
│  Event Instance: [Select...]        │
│                                     │
│  [Start Scanning Session] (disabled)│
└─────────────────────────────────────┘
```

### After Date Selection
```
┌─────────────────────────────────────┐
│  Event Date: [10/29/2025]           │
│                                     │
│  Event Instance:                    │
│  ┌─────────────────────────────┐  │
│  │ Fall Conference - Morning    │  │
│  │ Fall Conference - Afternoon  │  │
│  │ Workshop Series - Session 1  │  │
│  └─────────────────────────────┘  │
│                                     │
│  [Start Scanning Session] (enabled) │
└─────────────────────────────────────┘
```

### No Instances Found
```
┌─────────────────────────────────────┐
│  Event Date: [10/29/2025]           │
│                                     │
│  ⚠️ No event instances found for    │
│     the selected date.              │
│                                     │
│  [Start Scanning Session] (disabled)│
└─────────────────────────────────────┘
```

---

## Technical Implementation

### Database Schema
- **Summit Event Instance** object has these key fields:
  - `summit__Instance_Start_Date__c` - Used to filter by date
  - `summit__Instance_Title__c` - Displayed in dropdown
  - `summit__Active__c` - Only active instances shown
  - `summit__Event__r.Name` - Event name for dropdown label

### Apex Methods

#### `getEventInstancesByDate(Date selectedDate)`
Queries and returns event instances for a specific date.

**Parameters:**
- `selectedDate` - The date to filter instances by

**Returns:**
- `List<EventInstanceOption>` - List of instances with:
  - `value` - Instance ID
  - `label` - "Event Name - Instance Title"
  - `eventName` - Event name
  - `instanceTitle` - Instance title

**SOQL Query:**
```sql
SELECT Id, Name, summit__Instance_Title__c,
       summit__Event__r.Name,
       summit__Instance_Start_Date__c,
       summit__Instance_Start_Time__c
FROM summit__Summit_Events_Instance__c
WHERE summit__Instance_Start_Date__c = :selectedDate
  AND summit__Active__c = true
ORDER BY summit__Instance_Start_Time__c, summit__Event__r.Name
```

#### Updated Methods with Instance Filtering

**`checkInRegistrant(String qrCodeValue, String instanceId)`**
- Now requires `instanceId` parameter
- Filters registration query: `AND summit__Event_Instance__c = :instanceId`

**`searchRegistrations(String firstName, String lastName, String instanceId)`**
- Now requires `instanceId` parameter
- Filters registration query: `AND summit__Event_Instance__c = :instanceId`

**`checkInRegistrantById(String registrationId, String instanceId)`**
- Now requires `instanceId` parameter
- Filters registration query: `AND summit__Event_Instance__c = :instanceId`

---

## LWC Component Updates

### New Properties
```javascript
@track selectedDate = '';
@track selectedInstanceId = '';
@track instanceOptions = [];
@track loadingInstances = false;
@track noInstancesFound = false;
```

### Event Handlers

**`handleDateChange(event)`**
- Captures selected date
- Calls `getEventInstancesByDate` Apex method
- Populates `instanceOptions` array
- Shows loading spinner during fetch

**`handleInstanceChange(event)`**
- Captures selected instance ID
- Enables "Start Scanning Session" button

**`handleStartSession()`**
- Validates instance is selected
- Stores `selectedInstanceId` for session
- Proceeds to active session view

### Instance Scoping
All check-in operations pass `this.selectedInstanceId`:
```javascript
checkInRegistrant({ 
    qrCodeValue: this.qrCodeInput.trim(),
    instanceId: this.selectedInstanceId
})

searchRegistrations({
    firstName: this.firstName,
    lastName: this.lastName,
    instanceId: this.selectedInstanceId
})

checkInRegistrantById({
    registrationId: this.selectedRegistration.registrationId,
    instanceId: this.selectedInstanceId
})
```

---

## Benefits

### 1. Data Integrity
✅ Prevents checking in registrants to wrong event
✅ Ensures accurate attendance tracking per instance
✅ Validates registrant belongs to selected event

### 2. User Experience
✅ Clear visual workflow (date → instance → scan)
✅ Only shows relevant instances for selected date
✅ Prevents common operator errors

### 3. Reporting
✅ Accurate check-in counts per instance
✅ Better analytics on event attendance
✅ Proper scoping for multi-event days

### 4. Multi-Event Support
✅ Handles multiple events on same date
✅ Handles multiple instances of same event
✅ Clear instance selection for operators

---

## Edge Cases Handled

### No Instances Found
- Shows warning message
- Keeps Start button disabled
- User must select different date

### Invalid QR Code for Instance
- Returns error: "No registration found with this QR code"
- Prevents cross-event check-ins
- User sees clear error message

### Missing Instance Parameter
- Returns error: "Event instance must be selected"
- Server-side validation
- Prevents API misuse

### Multiple Instances at Same Time
- Orders by start time, then event name
- All instances shown in dropdown
- User makes final selection

---

## Testing

### Test Coverage Includes:
- ✅ Get instances by date (valid date)
- ✅ Get instances by date (no results)
- ✅ Get instances by date (null date)
- ✅ Check-in with correct instance
- ✅ Check-in with wrong instance (should fail)
- ✅ Check-in with missing instance (should fail)
- ✅ Manual lookup scoped to instance
- ✅ Search scoped to instance

### Manual Testing Steps:
1. Open check-in component
2. Select today's date → verify instances load
3. Select future date with no events → verify warning shows
4. Select instance → verify Start button enables
5. Start session → scan QR → verify only registrants for that instance check in
6. Try manual lookup → verify only shows registrants for that instance

---

## Migration Notes

### Breaking Changes
⚠️ **API Change**: All check-in methods now require `instanceId` parameter

**Before:**
```apex
checkInRegistrant(qrCodeValue)
searchRegistrations(firstName, lastName)
checkInRegistrantById(registrationId)
```

**After:**
```apex
checkInRegistrant(qrCodeValue, instanceId)
searchRegistrations(firstName, lastName, instanceId)
checkInRegistrantById(registrationId, instanceId)
```

### Deployment Checklist
- [ ] Deploy updated Apex class
- [ ] Deploy updated LWC component
- [ ] Run all test classes (should pass)
- [ ] Test with real event data
- [ ] Update any external integrations calling these methods

---

## Future Enhancements

### Potential Improvements:
1. **Remember Last Selected Instance**
   - Store last instance in session/local storage
   - Pre-populate on next load

2. **Quick Switch Instance**
   - Allow switching instance mid-session
   - Confirm dialog to prevent accidents

3. **Multi-Instance Check-In**
   - Allow checking in to multiple instances at once
   - Useful for all-day events

4. **Instance Auto-Detection**
   - Auto-select if only one instance today
   - Skip dropdown when obvious

5. **Recent Instances**
   - Show recently used instances at top
   - Faster for repeat check-in operators

---

## Summary

✅ **Date selection filters available instances**  
✅ **Instance selection scopes entire session**  
✅ **All operations filtered by instance ID**  
✅ **Prevents cross-event check-in errors**  
✅ **Comprehensive test coverage**  
✅ **Clear user experience flow**

This feature ensures data integrity and provides a professional, error-free check-in experience for multi-event scenarios.

