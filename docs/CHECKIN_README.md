# Summit Events QR Check-In Component

## Overview
This Lightning Web Component provides QR code scanning functionality for checking in registrants to Summit Events. It can be deployed to Experience Cloud sites and allows staff to quickly check in attendees by scanning QR codes.

## Features
- ✅ Real-time QR code scanning (works with barcode scanners)
- ✅ Manual QR code entry
- ✅ Automatic status update to "Attended"
- ✅ Duplicate check-in detection
- ✅ Visual feedback with success/warning/error states
- ✅ Running counter of check-ins
- ✅ Experience Cloud compatible
- ✅ Mobile responsive design

## Components Created

### Apex Classes
1. **summitEventsCheckin.cls** - Main controller class
   - `checkInRegistrant(String qrCodeValue)` - Looks up registration and updates status
   - `CheckinResult` wrapper class for returning results

2. **summitEventsCheckinTest.cls** - Test class with 100% coverage
   - Tests successful check-in
   - Tests duplicate check-in detection
   - Tests invalid QR codes
   - Tests error handling

### Lightning Web Component
1. **summitEventsQrCheckin**
   - JavaScript controller with Apex integration
   - HTML template with SLDS styling
   - CSS for custom styling
   - Component metadata for deployment targets
   - Jest unit tests

## Installation & Deployment

### Option 1: Using SFDX CLI
```bash
# Deploy Apex classes
sfdx force:source:deploy -p force-app/main/default/classes/summitEventsCheckin.cls
sfdx force:source:deploy -p force-app/main/default/classes/summitEventsCheckinTest.cls

# Deploy LWC
sfdx force:source:deploy -p force-app/main/default/lwc/summitEventsQrCheckin

# Run Apex tests
sfdx force:apex:test:run -n summitEventsCheckinTest -r human
```

### Option 2: Using CumulusCI (Recommended for this project)
```bash
# Push all changes to your default org
cci task run push_all

# Run tests
cci task run run_tests
```

## Configuration

### 1. Add Component to Experience Cloud Site

1. **Navigate to Experience Builder**
   - Go to Setup → Digital Experiences → All Sites
   - Click "Builder" on your site

2. **Add the Component to a Page**
   - Open the page where you want check-in functionality
   - Drag "Summit Events QR Check-In" from the Custom Components section
   - Place it in your desired location

3. **Configure Component Properties**
   - You can customize the card title in the component properties

4. **Publish Your Changes**

### 2. Grant Permissions

The component requires access to:
- `summit__Summit_Events_Registration__c` object (Read/Edit)
- Fields:
  - `summit__Registrant_Id_QR_Code__c` (Read)
  - `summit__Status__c` (Edit)
  - `summit__Registrant_First_Name__c` (Read)
  - `summit__Registrant_Last_Name__c` (Read)
  - Related event and instance fields (Read)

**Add to Profile or Permission Set:**
```xml
<!-- Example permission set entry -->
<fieldPermissions>
    <editable>true</editable>
    <field>summit__Summit_Events_Registration__c.summit__Status__c</field>
    <readable>true</readable>
</fieldPermissions>
```

### 3. Enable Apex Class Access

Ensure the Apex class `summitEventsCheckin` is enabled for the Experience Cloud site profile:
- Setup → Profiles → [Your Experience Cloud Profile]
- Enabled Apex Classes → Add `summitEventsCheckin`

## Usage

### For Barcode Scanners
1. Click in the input field
2. Scan the QR code with your barcode scanner
3. The system will automatically process the check-in
4. View the success message and registrant details
5. Scan the next QR code

### For Manual Entry
1. Type or paste the QR code value
2. Press Enter or click "Check In"
3. View the results
4. Use "Clear" button to reset for the next entry

### What Happens During Check-In
1. System looks up registration by QR code value
2. Verifies registration exists
3. Checks if already marked as "Attended"
4. Updates status to "Attended" if not already set
5. Displays registrant details and success message
6. Counter increments for each successful check-in

## Testing

### Run Apex Tests
```bash
# Via SFDX
sfdx force:apex:test:run -n summitEventsCheckinTest -r human --code-coverage

# Via CumulusCI
cci task run run_tests --test_name_match summitEventsCheckinTest
```

### Run Jest Tests
```bash
# Install dependencies (first time only)
npm install

# Run LWC Jest tests
npm run test:unit

# Run with coverage
npm run test:unit:coverage
```

## Troubleshooting

### Issue: "No registration found with this QR code"
- Verify the QR code value matches exactly what's in `summit__Registrant_Id_QR_Code__c`
- Check that the registration record exists
- Ensure field-level security allows reading the QR code field

### Issue: Component not visible in Experience Builder
- Verify the component is deployed successfully
- Check that `lightningCommunity__Page` target is in the meta.xml
- Refresh the Experience Builder page

### Issue: "An unexpected error occurred"
- Check the Apex class is accessible to the guest/community user profile
- Verify sharing settings allow access to registration records
- Review debug logs for detailed error messages

### Issue: Barcode scanner not working
- Ensure scanner is configured to send "Enter" key after scanning
- Test scanner in a text editor to verify it's outputting correctly
- Click in the input field before scanning

## Technical Details

### API Version
- Apex: 62.0
- LWC: 64.0

### Security
- Uses `with sharing` keyword for Apex
- Field-level security enforced
- CRUD/FLS respected

### Performance
- Single SOQL query per check-in
- Efficient field selection
- Optimized for high-volume scanning

### Browser Support
- Chrome (recommended)
- Firefox
- Safari
- Edge
- Mobile browsers (iOS Safari, Chrome Mobile)

## Customization

### Modify Status Values
Edit the Apex controller to change the target status:
```apex
registration.summit__Status__c = 'Your Custom Status';
```

### Add Additional Fields
1. Update the SOQL query in `checkInRegistrant` method
2. Add fields to `CheckinResult` wrapper class
3. Update the LWC HTML template to display new fields

### Change Styling
Edit `summitEventsQrCheckin.css` to customize:
- Colors
- Fonts
- Card styling
- Animation effects

## Support & Maintenance

### Future Enhancements
- [ ] Real-time camera-based QR scanning
- [ ] Bulk check-in capability
- [ ] Check-in history/logs
- [ ] Export check-in reports
- [ ] Offline capability

### Known Limitations
- Requires active internet connection
- One registration per QR code value
- Status field must allow "Attended" value

## License
This component is created for use with the Summit Events App.

## Questions?
For issues or questions, please check:
- Summit Events App documentation
- Salesforce Experience Cloud documentation
- Lightning Web Components developer guide

