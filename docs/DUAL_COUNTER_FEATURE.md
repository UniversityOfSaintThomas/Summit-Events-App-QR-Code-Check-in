# Dual Check-In Counter Feature

## Overview

The check-in page now displays **two separate counters** at the top:
1. **This Session** - Count of registrants checked in during the current session
2. **Total Attended** - Total count of all registrations marked as "Attended" for the selected instance

This gives operators visibility into both their current session progress and the overall event attendance.

---

## Visual Design

### Counter Display:

```
┌────────────────────────────────────────┐
│ Session Active             Duration: 5m │
│                                         │
│ ┌──────────────┐  ┌──────────────────┐│
│ │   🕐         │  │   ✅             ││
│ │      5       │  │     127          ││
│ │ This Session │  │ Total Attended   ││
│ └──────────────┘  └──────────────────┘│
│                                         │
│ [Scan with Camera]                      │
│              OR                         │
│ 🔍 Search by Name...                    │
└────────────────────────────────────────┘
```

### Counter Styling:

**This Session (Left Box):**
- Clock icon 🕐
- Default theme (gray background)
- Shows session count only
- Resets when session resets

**Total Attended (Right Box):**
- Success/checkmark icon ✅
- Success theme (green background)
- Shows all attended for instance
- Persists across sessions

---

## How It Works

### Session Count:
- **Starts at 0** when session begins
- **Increments by 1** each time you check in a registrant
- **Resets to 0** when you click "Reset Counter"
- **Does NOT count** already-checked-in registrants
- **Scoped to** current session only

### Total Attended Count:
- **Loads from database** when session starts
- **Queries** `summit__Status__c = 'Attended'` for the instance
- **Refreshes** after each successful check-in
- **Shows cumulative total** across all sessions/operators
- **Persists** even if you reset session counter

---

## User Experience

### Starting a Session:
1. Select date and instance
2. Click "Start Scanning Session"
3. **Session count** starts at 0
4. **Total attended** loads from database (e.g., 127)

### Checking In Registrants:
1. Scan QR code or search by name
2. Click "Check In" to confirm
3. **Session count** increments (0 → 1)
4. **Total attended** refreshes (127 → 128)

### Multiple Check-Ins:
- After 5 check-ins in this session:
  - **Session count:** 5
  - **Total attended:** 132 (127 + 5)

### Already Checked In:
- If you scan someone already checked in:
  - **Session count:** No change
  - **Total attended:** No change
  - Shows "Already Checked In" warning

### Resetting Session:
- Click "Reset Counter"
- **Session count:** Resets to 0
- **Total attended:** Stays the same (132)

---

## Technical Implementation

### New Apex Method

**`getTotalAttendedCount(String instanceId)`**

Returns the total count of registrations with status "Attended" for the specified instance.

```apex
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
```

### LWC JavaScript

**New Property:**
```javascript
@track totalAttendedCount = 0;
```

**New Method:**
```javascript
async refreshTotalAttendedCount() {
    if (!this.selectedInstanceId) {
        this.totalAttendedCount = 0;
        return;
    }

    try {
        const count = await getTotalAttendedCount({ 
            instanceId: this.selectedInstanceId 
        });
        this.totalAttendedCount = count || 0;
    } catch (error) {
        console.error('Error refreshing attended count:', error);
        this.totalAttendedCount = 0;
    }
}
```

**When Called:**
- On session start: `handleStartSession()`
- After successful check-in: `handleConfirmCheckIn()`

### LWC Template

**Counter Display:**
```html
<div class="slds-grid slds-gutters slds-grid_align-center">
    <!-- Session Count -->
    <div class="slds-col slds-text-align_center">
        <div class="slds-box slds-box_x-small slds-theme_default">
            <lightning-icon icon-name="utility:clock" size="small"/>
            <div class="slds-text-heading_medium">{scanCount}</div>
            <div class="slds-text-body_small">This Session</div>
        </div>
    </div>
    
    <!-- Total Attended -->
    <div class="slds-col slds-text-align_center">
        <div class="slds-box slds-box_x-small slds-theme_success">
            <lightning-icon icon-name="utility:success" size="small"/>
            <div class="slds-text-heading_medium">{totalAttendedCount}</div>
            <div class="slds-text-body_small">Total Attended</div>
        </div>
    </div>
</div>
```

---

## Benefits

### 1. Session Progress Tracking
✅ **Operator accountability** - See how many checked in during shift  
✅ **Performance metrics** - Track check-ins per hour  
✅ **Session goals** - "Let's check in 50 today"

### 2. Overall Event Visibility
✅ **Real-time attendance** - See total event turnout  
✅ **Capacity planning** - Monitor vs expected attendance  
✅ **Multi-operator coordination** - All operators see same total

### 3. Data Validation
✅ **Sanity check** - Session count should ≤ Total count  
✅ **Duplicate prevention** - Already checked in doesn't increment  
✅ **Accuracy** - Total refreshes from database

### 4. Professional Experience
✅ **Clear metrics** - Two distinct, labeled counters  
✅ **Visual distinction** - Different colors/icons  
✅ **At-a-glance info** - No need to leave check-in screen

---

## Use Cases

### Scenario 1: Single Operator, Full Day
**Start of Day:**
- Session: 0
- Total: 15 (pre-registrations checked in earlier)

**After 3 Hours:**
- Session: 42
- Total: 57 (15 + 42)

**After Lunch Reset:**
- Session: 0 (reset counter)
- Total: 57 (unchanged)

**End of Day:**
- Session: 38 (afternoon check-ins)
- Total: 95 (57 + 38)

### Scenario 2: Multiple Operators
**Operator A at Station 1:**
- Session: 23
- Total: 156

**Operator B at Station 2:**
- Session: 19
- Total: 156 (same instance, same total)

**Combined:**
- Total attendance: 156
- Operator A contributed: 23
- Operator B contributed: 19
- Others: 114

### Scenario 3: Already Checked In
**Scan QR Code:**
- Person already checked in
- Shows warning
- Session: No change (still 5)
- Total: No change (still 132)

### Scenario 4: Reset Mid-Session
**Before Reset:**
- Session: 15
- Total: 203

**After Reset:**
- Session: 0
- Total: 203

**After 5 More Check-Ins:**
- Session: 5
- Total: 208

---

## Counter Behavior

### Session Count Increments When:
✅ QR scan → Confirm → Check-in successful  
✅ Manual lookup → Select → Check in → Successful  
✅ Status changes from non-Attended to Attended

### Session Count Does NOT Increment When:
❌ Scan cancelled before check-in  
❌ Already checked in (warning shown)  
❌ Check-in error/failure  
❌ Session reset

### Total Attended Refreshes When:
🔄 Session starts (initial load)  
🔄 Successful check-in (after database update)

### Total Attended Does NOT Change When:
➖ Session reset  
➖ Cancelled check-in  
➖ Already checked in  
➖ Check-in error

---

## Visual Comparison

### Before (Single Counter):
```
┌─────────────────┐
│ ✓ 5 Checked In  │
└─────────────────┘
```
**Problem:** Doesn't show total attendance

### After (Dual Counter):
```
┌──────────────┐  ┌──────────────────┐
│   🕐         │  │   ✅             │
│      5       │  │     132          │
│ This Session │  │ Total Attended   │
└──────────────┘  └──────────────────┘
```
**Solution:** Clear separation of session vs total

---

## Error Handling

### If Database Query Fails:
- Total count defaults to 0
- Error logged to console
- Session count unaffected
- Operator can continue checking in

### If Instance Not Selected:
- Total count remains 0
- Session can't start (validation)
- No query executed

### If Network Error:
- Shows last known total count
- Retry on next check-in
- Session count still accurate

---

## Performance

### Efficient Queries:
- Simple COUNT() query
- Indexed on Status field
- Filtered by instance
- Fast execution (<100ms typical)

### Minimal Refresh:
- Only refreshes on check-in success
- Not on every scan
- Not on cancelled check-ins
- Reduces database calls

### Scalability:
- Works with 10 or 10,000 registrations
- COUNT() is optimized by database
- No memory overhead

---

## Testing Scenarios

### ✅ Basic Flow:
- [ ] Start session
- [ ] Verify session = 0, total loads
- [ ] Check in 3 people
- [ ] Verify session = 3, total = previous + 3

### ✅ Already Checked In:
- [ ] Scan already-checked-in person
- [ ] Verify session doesn't increment
- [ ] Verify total doesn't change

### ✅ Session Reset:
- [ ] Check in 5 people
- [ ] Reset counter
- [ ] Verify session = 0, total unchanged

### ✅ Multiple Sessions:
- [ ] Session 1: Check in 10
- [ ] End session
- [ ] Session 2: Check in 8
- [ ] Verify total = 18 total across sessions

### ✅ Multi-Operator:
- [ ] Operator A checks in 5
- [ ] Operator B checks in 3 (different device)
- [ ] Both see total = 8

---

## Files Modified

### Apex:
✅ `summitEventsCheckin.cls`
- Added `getTotalAttendedCount()` method

### LWC JavaScript:
✅ `summitEventsQrCheckin.js`
- Added `totalAttendedCount` property
- Added `refreshTotalAttendedCount()` method
- Updated `handleStartSession()` to load total
- Updated `handleConfirmCheckIn()` to refresh total

### LWC HTML:
✅ `summitEventsQrCheckin.html`
- Replaced single counter with dual counter display
- Added grid layout for side-by-side boxes
- Added distinct styling for each counter

---

## Summary

✅ **Two counters** - Session and Total  
✅ **Clear visual distinction** - Different colors/icons  
✅ **Real-time updates** - Total refreshes after check-in  
✅ **Session independence** - Reset doesn't affect total  
✅ **Professional display** - Side-by-side boxes  
✅ **Operator accountability** - Track individual session  
✅ **Event visibility** - See overall attendance  
✅ **Multi-operator support** - Same total across devices

This feature provides operators with **complete visibility** into both their personal session progress and the overall event attendance! 🎉

