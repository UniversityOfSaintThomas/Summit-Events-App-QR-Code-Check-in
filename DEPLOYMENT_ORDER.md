# Summit Events QR Check-In - Deployment Guide

**Version 1.0** | Step-by-Step Deployment Instructions

---

## 📋 Pre-Deployment Checklist

Before deploying, ensure you have:

- [ ] Salesforce Summit Events App installed in target org
- [ ] Salesforce CLI installed (`sf` command available)
- [ ] Authenticated to target org (`sf org login web`)
- [ ] Admin access to target org
- [ ] Backup of org taken (recommended for production)

**Check your CLI version:**
```bash
sf version
# Should be v2.0.0 or higher
```

---

## ⚠️ Important: Two-Phase Deployment Required

**Why?** The LWC component references Apex methods. If deployed together, the LWC tries to validate against methods that don't exist yet, causing errors like:
```
Unable to find Apex action method referenced as 'summitEventsCheckin.getEventInstancesByDate'
```

**Solution:** Deploy Apex classes FIRST, then LWC components.

---

## 🚀 Phase 1: Deploy Apex Classes

Deploy the Apex controller and test class first:

```bash
cd c:\Users\Thad-PC-2019\IdeaProjects\Summit-Evetns-App-Checkin
sf project deploy start --source-dir force-app/main/default/classes --wait 10
```

**What's being deployed:**
- `summitEventsCheckin.cls` - Main Apex controller (7 methods)
- `summitEventsCheckinTest.cls` - Test class (35 tests)
- Associated `.cls-meta.xml` files

**Expected output:**
```
Status: Succeeded
Deployed Source:
  - summitEventsCheckin (ApexClass)
  - summitEventsCheckinTest (ApexClass)
```

**⏱️ Wait for:** "Status: Succeeded" message

---

## ✅ Phase 2: Run Apex Tests

Verify Apex deployment with comprehensive test execution:

```bash
sf apex run test --class-names summitEventsCheckinTest --code-coverage --result-format human --wait 10
```

**Expected results:**
```
Tests Ran: 35
Pass Rate: 100%
Code Coverage: 89%
Status: Passed ✅
```

**If tests fail:**
1. Check error messages for specific failures
2. Verify Summit Events App is installed
3. Ensure test data can be created
4. Check object/field permissions

---

## 🎨 Phase 3: Deploy Static Resources

Deploy the jsQR library for camera scanning:

```bash
sf project deploy start --source-dir force-app/main/default/staticresources --wait 10
```

**What's being deployed:**
- `jsQR.js` - QR code scanning library
- `jsQR.resource-meta.xml` - Metadata file

**Expected output:**
```
Status: Succeeded
Deployed Source:
  - jsQR (StaticResource)
```

---

## 🖥️ Phase 4: Deploy LWC Component

Now deploy the Lightning Web Component:

```bash
sf project deploy start --source-dir force-app/main/default/lwc/summitEventsQrCheckin --wait 10
```

**What's being deployed:**
- `summitEventsQrCheckin.js` - JavaScript controller
- `summitEventsQrCheckin.html` - User interface template
- `summitEventsQrCheckin.css` - Component styling
- `summitEventsQrCheckin.js-meta.xml` - Component metadata
- `__tests__/summitEventsQrCheckin.test.js` - Jest unit tests

**Expected output:**
```
Status: Succeeded
Deployed Source:
  - summitEventsQrCheckin (LightningComponentBundle)
```

**⚠️ If you get an error about Apex methods:**
- This means Phase 1 didn't complete successfully
- Re-run Phase 1 and wait for "Status: Succeeded"
- Then retry Phase 4

---

## 🔐 Phase 5: Configure Permissions

### For Experience Cloud (Guest/External Users)

1. **Navigate to:** Setup → Digital Experiences → All Sites → [Your Site] → Workspaces

2. **Edit Profile/Permission Set:**
   - Go to: Administration → Members → [Profile/Permission Set]

3. **Enable Apex Class:**
   - Select: Enabled Apex Class Access
   - Add: `summitEventsCheckin`
   - Save

4. **Object Permissions:**
   ```
   Summit Events Registration:
     ☑ Read
     ☑ Edit
   
   Summit Events Instance:
     ☑ Read
   
   Summit Events:
     ☑ Read
   ```

5. **Field-Level Security:**
   - Ensure Read access on all fields used
   - Ensure Edit access on `Status` field

### For Internal Users

1. **Create or Edit Permission Set:**
   - Setup → Permission Sets → New (or edit existing)

2. **Add Apex Class:**
   - Apex Class Access → Add → `summitEventsCheckin`

3. **Add Object Permissions:** (same as above)

4. **Assign to Users:**
   - Permission Set → Manage Assignments → Add Assignments

---

## 📱 Phase 6: Add Component to Page

### Lightning App Builder (Internal)

1. **Edit Home Page or Custom Page:**
   - Setup → App Builder → Edit [Page]

2. **Add Component:**
   - Components panel → Search "Summit Events"
   - Drag "Summit Events QR Check-In" to page
   - Configure title property if desired

3. **Save and Activate:**
   - Save
   - Activate (assign to org/app/profile as needed)

### Experience Builder (External)

1. **Open Experience Builder:**
   - Digital Experiences → [Your Site] → Builder

2. **Navigate to Page:**
   - Select or create check-in page

3. **Add Component:**
   - Components (+) → Search "Summit"
   - Drag to page
   - Configure properties in right panel

4. **Publish:**
   - Click "Publish" (top right)

---

## ✅ Phase 7: Verification & Testing

### Verify Deployment

**1. Check Apex Classes:**
```bash
sf apex list --json | findstr "summitEventsCheckin"
```
Should show both classes

**2. Check LWC:**
- Setup → Lightning Components
- Search: `summitEventsQrCheckin`
- Should appear in list

**3. Check Static Resource:**
- Setup → Static Resources
- Search: `jsQR`
- Should appear with size ~50KB

### Test Component

**1. Open Check-In Page:**
- Navigate to page where component was added
- Component should be visible

**2. Test Date Selection:**
- Click date picker
- Select a date
- Instance dropdown should populate (if instances exist for that date)

**3. Test Session Start:**
- Select an instance from dropdown
- Click "Start Scanning Session"
- Interface should change to show:
  - Session active indicator
  - Counters
  - Scan with Camera button
  - Search fields

**4. Test Camera (if available):**
- Click "Scan with Camera"
- Grant permission when prompted
- Camera view should appear inline
- Click "Cancel Scanning" to close

**5. Test Manual Search:**
- Enter a name in First Name or Last Name
- Click "Search"
- Results should appear (if registrations exist)

**6. Test Check-In Flow:**
- Search for a registration
- Click result
- Details should display
- Click "Check In"
- Success message should appear
- Counter should increment

### Create Test Data (if needed)

If you need test registrations, create them via:

1. **Manual Creation:**
   - App Launcher → Summit Events App
   - Create Event → Create Instance → Create Registrations

2. **Data Loader:**
   - Import registrations via CSV

3. **Anonymous Apex:**
   - See test data examples in test class

---

## 🔄 Rollback Procedure

If you need to rollback the deployment:

### Option 1: Undeploy via CLI

```bash
# Remove LWC
sf project delete source --source-dir force-app/main/default/lwc/summitEventsQrCheckin --no-prompt

# Remove Static Resource
sf project delete source --source-dir force-app/main/default/staticresources/jsQR.js --no-prompt

# Remove Apex (⚠️ Only if safe - check dependencies)
sf project delete source --source-dir force-app/main/default/classes/summitEventsCheckin.cls --no-prompt
```

### Option 2: Manual Removal

1. Setup → Apex Classes → Delete `summitEventsCheckin` and `summitEventsCheckinTest`
2. Setup → Lightning Components → Delete `summitEventsQrCheckin`
3. Setup → Static Resources → Delete `jsQR`

**⚠️ Warning:** Deleting Apex classes will break any pages using the component.

---

## 🐛 Troubleshooting Deployment

### Issue: "Unable to find Apex action method"

**Cause:** LWC deployed before Apex  
**Solution:** 
1. Delete LWC deployment: `sf project delete source --source-dir force-app/main/default/lwc/summitEventsQrCheckin`
2. Redeploy Apex: See Phase 1
3. Redeploy LWC: See Phase 4

### Issue: Test Failures

**Cause:** Missing test data or permissions  
**Solution:**
1. Check error message for specific field/object
2. Verify Summit Events App is installed
3. Run tests with debug logs enabled
4. Check test class for data creation issues

### Issue: "Component not found in Experience Builder"

**Cause:** Metadata not configured correctly  
**Solution:**
1. Check `summitEventsQrCheckin.js-meta.xml`
2. Verify `<target>` includes `lightningCommunity__Page`
3. Refresh Experience Builder (Ctrl+Shift+R)

### Issue: Permission Errors

**Cause:** Missing object/class permissions  
**Solution:**
1. Verify all steps in Phase 5 completed
2. Check profile/permission set assignments
3. Test as actual user (not admin)
4. Review debug logs for specific permission errors

### Issue: Camera Not Working

**Cause:** Browser permissions or incompatible browser  
**Solution:**
1. Check browser compatibility (Chrome 83+, etc.)
2. Grant camera permission in browser
3. Check browser console for errors (F12)
4. Try different browser

---

## 📊 Post-Deployment Checklist

After successful deployment, verify:

- [ ] Apex classes deployed (2 classes)
- [ ] Tests passing (35 tests, 89% coverage)
- [ ] Static resource deployed (jsQR)
- [ ] LWC component deployed
- [ ] Permissions configured for all users
- [ ] Component added to page(s)
- [ ] Test check-in performed successfully
- [ ] Camera scanning tested (if applicable)
- [ ] Manual search tested
- [ ] Documentation reviewed by staff
- [ ] Support contacts identified
- [ ] Monitoring/debug logs enabled

---

## 📈 Deployment to Production

### Best Practices

1. **Test in Sandbox First:**
   - Deploy to full sandbox
   - Test all functionality
   - Train staff in sandbox
   - Document any issues

2. **Schedule Deployment:**
   - Choose low-traffic time
   - Notify users of maintenance window
   - Have rollback plan ready

3. **Deployment Day:**
   - Follow phases in order
   - Verify each phase before continuing
   - Test immediately after deployment
   - Monitor debug logs

4. **Post-Deployment:**
   - Verify with test check-in
   - Monitor first live event closely
   - Collect staff feedback
   - Document lessons learned

---

## 🆘 Support Resources

- **Documentation:** `docs/` folder in repository
- **User Guide:** `docs/USER-GUIDE.md`
- **Architecture:** `docs/ARCHITECTURE.md`
- **Release Notes:** `docs/V1.0-RELEASE-NOTES.md`

**Debug Commands:**
```bash
# View recent logs
sf apex log list

# Get specific log
sf apex log get --log-id [LOG_ID]

# Check deployment status
sf project deploy report

# List deployed components
sf project list
```

---

## ✅ Deployment Complete!

If all phases completed successfully, you now have:

✅ Apex controller with 7 methods deployed  
✅ Test class with 35 tests (89% coverage) passing  
✅ jsQR static resource deployed  
✅ LWC component deployed and functional  
✅ Permissions configured  
✅ Component available on page  
✅ System tested and verified  

**Next Steps:**
1. Train staff using `docs/USER-GUIDE.md`
2. Test with real event data
3. Monitor first live event
4. Collect feedback for improvements

**You're ready for event check-ins! 🎉**

