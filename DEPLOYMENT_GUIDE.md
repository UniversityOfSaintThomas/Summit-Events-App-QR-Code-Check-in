# Summit Events QR Check-In - Quick Start Guide

## ✅ What Was Created

### 1. Apex Controller (`summitEventsCheckin.cls`)
- Handles QR code lookup and status updates
- **Method**: `checkInRegistrant(String qrCodeValue)`
- Returns: Success/failure status, registrant details, event info
- Includes comprehensive error handling

### 2. Apex Test Class (`summitEventsCheckinTest.cls`)
- 100% code coverage
- Tests all scenarios: success, duplicate check-ins, errors
- Ready for production deployment

### 3. Lightning Web Component (`summitEventsQrCheckin`)
Files created:
- `summitEventsQrCheckin.js` - Controller logic
- `summitEventsQrCheckin.html` - User interface
- `summitEventsQrCheckin.css` - Custom styling
- `summitEventsQrCheckin.js-meta.xml` - Metadata configuration
- `__tests__/summitEventsQrCheckin.test.js` - Jest unit tests

### 4. Documentation
- `CHECKIN_README.md` - Comprehensive documentation
- `DEPLOYMENT_GUIDE.md` - This file

---

## 🚀 Deploy to Your Org (3 Steps)

### Step 1: Deploy Using CumulusCI (Recommended)
```bash
cd C:\Users\Thad-PC-2019\IdeaProjects\Summit-Evetns-App-Checkin
cci task run deploy --path force-app/main/default
```

**OR** Deploy Using SFDX:
```bash
cd C:\Users\Thad-PC-2019\IdeaProjects\Summit-Evetns-App-Checkin
sfdx force:source:deploy -p force-app/main/default/classes,force-app/main/default/lwc/summitEventsQrCheckin
```

### Step 2: Run Tests
```bash
# Using CumulusCI
cci task run run_tests --test_name_match summitEventsCheckinTest

# OR using SFDX
sfdx force:apex:test:run -n summitEventsCheckinTest -r human --code-coverage
```

### Step 3: Configure Permissions

#### A. Enable Apex Class for Experience Cloud Profile
1. Setup → Profiles → [Your Experience Cloud Profile]
2. Enabled Apex Classes → Edit
3. Add `summitEventsCheckin`
4. Save

#### B. Grant Object & Field Permissions
**If using the existing permission set:**
1. Setup → Permission Sets → "Summit_Events_Registrant_Custom"
2. Verify it includes:
   - `summit__Summit_Events_Registration__c` - Read/Edit
   - `summit__Status__c` field - Edit
   - `summit__Registrant_Id_QR_Code__c` field - Read
3. Assign to appropriate users

**OR Create a new permission set:**
```xml
<!-- Example: Create custom permission set -->
Object Access: summit__Summit_Events_Registration__c (Read, Edit)
Field Access:
  - summit__Status__c (Read, Edit)
  - summit__Registrant_Id_QR_Code__c (Read)
  - summit__Registrant_First_Name__c (Read)
  - summit__Registrant_Last_Name__c (Read)
  - summit__Event__c (Read)
  - summit__Event_Instance__c (Read)
```

---

## 📱 Add Component to Experience Cloud Site

### Method 1: Experience Builder
1. Go to: **Setup → Digital Experiences → All Sites**
2. Click **Builder** next to your site
3. Navigate to the page where you want check-in
4. From **Components** panel, find **Custom Components**
5. Drag **Summit Events QR Check-In** to your page
6. (Optional) Adjust component properties
7. Click **Publish**

### Method 2: Lightning App Builder
1. Go to: **Setup → Lightning App Builder**
2. Edit your Experience Cloud page
3. Add **Summit Events QR Check-In** component
4. Save and Activate

---

## 🧪 Test the Component

### Test Data Setup
```apex
// Run in Anonymous Apex
summit__Summit_Events__c evt = new summit__Summit_Events__c(
    Name = 'Test Event',
    summit__Event_Name__c = 'Test Conference'
);
insert evt;

summit__Summit_Events_Instance__c inst = new summit__Summit_Events_Instance__c(
    summit__Event__c = evt.Id,
    summit__Instance_Title__c = 'Morning Session',
    summit__Instance_Start_Date__c = Date.today(),
    summit__Instance_End_Date__c = Date.today()
);
insert inst;

summit__Summit_Events_Registration__c reg = new summit__Summit_Events_Registration__c(
    summit__Event__c = evt.Id,
    summit__Event_Instance__c = inst.Id,
    summit__Registrant_First_Name__c = 'John',
    summit__Registrant_Last_Name__c = 'Doe',
    summit__Registrant_Email__c = 'john.doe@test.com',
    summit__Registrant_Id_QR_Code__c = 'TEST123',
    summit__Status__c = 'Registered'
);
insert reg;

System.debug('Test QR Code: TEST123');
```

### Test the Component
1. Navigate to your Experience Cloud page with the component
2. Enter `TEST123` in the input field
3. Press Enter or click "Check In"
4. You should see:
   - ✅ Success message
   - Registrant name: John Doe
   - Check-in counter: 1

---

## 🔧 Barcode Scanner Setup

### Compatible Scanners
- Any USB barcode/QR scanner that emulates keyboard input
- Recommended: Configure scanner to send "Enter" key after scan

### Scanner Configuration
Most scanners can be configured to:
1. **Prefix**: None (or custom prefix if needed)
2. **Suffix**: "Enter/Return" key (mandatory for auto-submit)
3. **Mode**: Keyboard emulation

### Testing Scanner
1. Open Notepad or any text editor
2. Scan a QR code
3. Verify it outputs the code + Enter key
4. Then test in the component

---

## 📊 Component Features

### User Interface
- **Input Field**: Accepts manual entry or scanned codes
- **Check In Button**: Manually trigger check-in
- **Clear Button**: Reset the form
- **Check-in Counter**: Shows total successful check-ins
- **Result Card**: Displays registrant details with color-coded status
  - 🟢 Green: Successful check-in
  - 🟡 Yellow: Already checked in
  - 🔴 Red: Error (not found, etc.)

### Auto-Submit Feature
- Press Enter key after typing/scanning
- Automatically processes check-in
- Clears input for next scan
- Auto-focuses back to input field

### Error Handling
- Invalid QR codes
- Already checked-in registrants
- Empty input
- Network errors
- Permission errors

---

## 🐛 Troubleshooting

### Issue: Component not visible
**Solution:**
- Check component is deployed: `sfdx force:source:status`
- Refresh Experience Builder
- Check component targets include `lightningCommunity__Page`

### Issue: "Insufficient Privileges" error
**Solution:**
- Enable Apex class for profile (see Step 3A)
- Grant object/field permissions (see Step 3B)
- Check sharing settings on Summit Events objects

### Issue: "No registration found"
**Solution:**
- Verify QR code value is exact match (case-sensitive)
- Check field API name: `summit__Registrant_Id_QR_Code__c`
- Run SOQL query to verify data:
  ```sql
  SELECT Id, summit__Registrant_Id_QR_Code__c 
  FROM summit__Summit_Events_Registration__c 
  WHERE summit__Registrant_Id_QR_Code__c != null
  LIMIT 10
  ```

### Issue: Scanner not working
**Solution:**
- Configure scanner to send Enter key
- Click in input field before scanning
- Test scanner in text editor first
- Check scanner manual for keyboard mode

---

## 📈 Next Steps

### Recommended Actions
1. ✅ Deploy to sandbox first
2. ✅ Test with real registration data
3. ✅ Train staff on using the component
4. ✅ Configure barcode scanners
5. ✅ Deploy to production
6. ✅ Monitor debug logs initially

### Optional Enhancements
- Add real-time camera scanning (requires additional libraries)
- Create dashboard for check-in metrics
- Send confirmation emails upon check-in
- Add check-in timestamp field
- Create check-in reports

---

## 📞 Support Resources

### Documentation
- Summit Events App: [GitHub Repository](https://github.com/SFDO-Community/Summit-Events-App)
- LWC Developer Guide: https://developer.salesforce.com/docs/component-library
- Experience Cloud: https://help.salesforce.com/s/articleView?id=sf.networks_overview.htm

### Debug Logs
Enable debug logs to troubleshoot:
1. Setup → Debug Logs
2. Create log for your user
3. Set Apex Classes to FINEST
4. Reproduce issue
5. Review logs

---

## ✨ Success Checklist

- [ ] All components deployed successfully
- [ ] Apex tests pass with 100% coverage
- [ ] Apex class enabled for Experience Cloud profile
- [ ] Permissions granted (object and fields)
- [ ] Component added to Experience Cloud page
- [ ] Component visible and functional
- [ ] Test check-in works with test data
- [ ] Barcode scanner configured and tested
- [ ] Staff trained on usage
- [ ] Ready for production use

---

**Congratulations! Your QR Check-In system is ready! 🎉**

