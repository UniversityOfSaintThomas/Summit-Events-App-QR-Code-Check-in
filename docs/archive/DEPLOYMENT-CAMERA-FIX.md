# Deployment Guide: Camera Fix

## What Was Fixed

The component was showing an incorrect "Camera Not Supported" error due to:

1. **Invalid `icon-name` attributes on `<lightning-badge>` components** - Lightning badges don't support icon-name
2. **Poor camera detection** - Not providing clear error messages about HTTPS requirements
3. **Lack of diagnostic logging** - Hard to troubleshoot camera issues

## Changes Made

### 1. HTML Template (`summitEventsQrCheckin.html`)
- ✅ Replaced `<lightning-badge>` with custom SLDS badge spans
- ✅ Added separate `<lightning-icon>` elements within badges
- ✅ Removed invalid `variant` attributes
- ✅ Fixed "Checked In" and status badges in search results
- ✅ Fixed "Already Checked In" warning badge

### 2. CSS (`summitEventsQrCheckin.css`)
- ✅ Added `.slds-badge` custom styles
- ✅ Added `.slds-theme_success` styles (green)
- ✅ Added `.slds-theme_warning` styles (yellow)
- ✅ Added icon alignment within badges

### 3. JavaScript (`summitEventsQrCheckin.js`)
- ✅ Added `checkCameraSupport()` method for diagnostics
- ✅ Improved `handleBrowserCameraScan()` with detailed checks
- ✅ Added HTTPS/secure context detection
- ✅ Split camera checks into separate, clear error messages
- ✅ Added comprehensive console logging for troubleshooting

## Deployment Steps

### Option 1: Deploy to Org (Recommended for Testing)

```bash
# Deploy all changes
sf project deploy start --target-org <your-org-alias>

# Or deploy just the LWC
sf project deploy start --source-dir force-app/main/default/lwc/summitEventsQrCheckin --target-org <your-org-alias>
```

### Option 2: Update Unlocked Package

```bash
# 1. Create new package version
sf package version create --package "Summit Events Check-In" --installation-key-bypass --wait 10

# 2. Note the new version ID (04t...)

# 3. Promote the version (when ready for production)
sf package version promote --package <version-id>

# 4. Install in target org
sf package install --package <version-id> --target-org <org-alias> --wait 10 --no-prompt
```

### Option 3: Quick Deploy (For immediate testing)

```bash
# Deploy without tests
sf project deploy start --source-dir force-app/main/default/lwc/summitEventsQrCheckin --target-org <your-org-alias> --ignore-conflicts
```

## Verification Steps

### 1. Check Deployment Success
```bash
sf project deploy report --target-org <your-org-alias>
```

### 2. Test in Browser
1. Open the Experience Cloud site where component is used
2. Press F12 to open Developer Console
3. Start a scanning session
4. Click "Scan with Camera"
5. Check console logs:

**Expected Success Logs:**
```
🔍 Checking camera support...
  - Protocol: https:
  - Secure context: true
  - navigator.mediaDevices: true
  - getUserMedia: true
✅ Camera support detected

🎥 Camera scan initiated
Session active: true
Secure context: true
navigator.mediaDevices available: true
getUserMedia available: true
jsQR loaded: true
jsQR library: true
✅ All checks passed - starting camera scanner
```

**If HTTPS Issue:**
```
❌ Camera requires secure context (HTTPS). Current protocol: http:
```
**Solution:** Access site via HTTPS

**If Browser Issue:**
```
❌ navigator.mediaDevices is not available
```
**Solution:** Use Chrome/Firefox/Edge

### 3. Test Scanning
1. Generate a test QR code containing text like "QR-ALICE-001"
2. Use online QR generator: https://www.qr-code-generator.com/
3. Show QR code to camera
4. Verify scan is detected and processed

### 4. Test Manual Search (Fallback)
1. Enter first name and last name
2. Click Search
3. Verify results appear
4. Select a registration
5. Click Check In
6. Verify success message

## Troubleshooting Post-Deployment

### Issue: Still seeing old error message
**Cause:** Browser cache or component not refreshed

**Solution:**
1. Hard refresh page: `Ctrl+Shift+R` (Windows) or `Cmd+Shift+R` (Mac)
2. Clear browser cache
3. Try incognito/private browsing mode
4. Verify deployment succeeded

### Issue: "Secure Connection Required" error
**Cause:** Site not using HTTPS

**Solution:**
1. Check URL - must start with `https://`
2. Experience Cloud sites should use HTTPS by default
3. If custom domain, verify SSL certificate
4. Contact Salesforce admin if needed

### Issue: "Camera API Not Available" error
**Cause:** Browser doesn't support camera API

**Solution:**
1. Update browser to latest version
2. Try different browser (Chrome/Firefox/Edge)
3. Check browser console for specific error
4. Use manual search as fallback

### Issue: Camera permission denied
**Cause:** User blocked camera access

**Solution:**
1. Click camera icon in browser address bar
2. Change permission to "Allow"
3. Refresh page
4. Try scanning again

## Testing Checklist

- [ ] Component deploys without errors
- [ ] Lightning badges display correctly with icons
- [ ] No console errors about invalid icon names
- [ ] Console shows diagnostic logs on component load
- [ ] "Scan with Camera" button works
- [ ] Appropriate error message if HTTPS not available
- [ ] Appropriate error message if browser doesn't support camera
- [ ] Camera opens when clicking "Scan with Camera" (on HTTPS)
- [ ] QR code scanning works
- [ ] Manual search works as fallback
- [ ] Check-in completes successfully
- [ ] "Checked In" badge shows checkmark icon
- [ ] "Already Checked In" warning badge shows warning icon
- [ ] Search results show status badges with icons

## Rolling Back (If Needed)

### If using direct deployment:
```bash
# Retrieve previous version from org
sf project retrieve start --source-dir force-app/main/default/lwc/summitEventsQrCheckin
```

### If using package:
```bash
# Install previous package version
sf package install --package <previous-version-id> --target-org <org-alias> --wait 10
```

## Support

If issues persist after deployment:

1. **Check deployment logs:**
   ```bash
   sf project deploy report --target-org <your-org-alias>
   ```

2. **Verify component version:**
   - Open component in Salesforce Setup
   - Check Last Modified date

3. **Review browser console:**
   - Look for camera diagnostic logs
   - Note any error messages
   - Check browser name/version

4. **Refer to troubleshooting guide:**
   - See `docs/CAMERA-TROUBLESHOOTING.md`

## Next Steps

After successful deployment:

1. ✅ Test in Experience Cloud site
2. ✅ Test with real QR codes
3. ✅ Test on mobile devices (iOS/Android)
4. ✅ Test in Salesforce Mobile App
5. ✅ Document any issues found
6. ✅ Train users on manual search fallback
7. ✅ Update package version if needed
8. ✅ Deploy to production

## Package Version Notes

When creating a new package version, include these notes:

**Version X.X.X - Camera Scanner Fix**
- Fixed invalid icon-name attributes on lightning-badge components
- Improved camera support detection and error messages
- Added HTTPS requirement detection
- Added comprehensive diagnostic logging
- Enhanced visual design of status badges
- Improved troubleshooting capabilities

**Breaking Changes:** None

**Migration:** No migration needed - deploy and test

**Known Issues:** Camera requires HTTPS access

