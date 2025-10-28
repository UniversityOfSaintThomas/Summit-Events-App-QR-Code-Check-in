# QR Check-In: Dual-Mode Scanning Support

## 🎯 Overview

The Summit Events QR Check-In component now supports **TWO scanning methods**:

1. **Desktop Mode**: USB/Bluetooth barcode scanners (keyboard emulation)
2. **Mobile Mode**: Native camera scanning via Salesforce Mobile App

This provides maximum flexibility for different event check-in scenarios!

---

## 📱 Mobile Device Scanning (NEW!)

### How It Works
When running in the **Salesforce Mobile App** on iOS or Android:
- Component detects mobile capability automatically
- **"Scan with Camera"** button appears
- Uses device's native camera to scan QR codes
- Automatic check-in after successful scan

### Supported Barcode Types
The mobile scanner supports:
- ✅ QR Code (primary)
- ✅ CODE_128
- ✅ CODE_39
- ✅ CODE_93
- ✅ DATA_MATRIX
- ✅ EAN_8
- ✅ EAN_13
- ✅ ITF
- ✅ PDF_417
- ✅ UPC_A
- ✅ UPC_E

### Using Mobile Camera Scanning

#### Step 1: Start Session
1. Open Experience Cloud site in Salesforce Mobile App
2. Navigate to check-in page
3. Click **"Start Scanning Session"**

#### Step 2: Scan with Camera
1. Click **"Scan with Camera"** button
2. Camera opens with scanning overlay
3. Point camera at registrant's QR code
4. Scan completes automatically
5. Check-in processes immediately

#### Step 3: Continue Scanning
1. After successful check-in, ready for next scan
2. Click "Scan with Camera" again
3. Repeat for each registrant

---

## 💻 Desktop Scanning (Original)

### How It Works
When running on desktop/laptop computers:
- USB or Bluetooth barcode scanner required
- Scanner configured for keyboard emulation
- Scans directly into input field
- Press Enter (or auto-submit) to check in

### Using USB/Bluetooth Scanners

#### Hardware Setup
1. **Connect Scanner**: USB or pair Bluetooth
2. **Configure Scanner** (if needed):
   - Mode: Keyboard emulation
   - Suffix: Send "Enter" key after scan
   - Prefix: None (or as required)

#### Scanning Workflow
1. **Start Session**: Click "Start Scanning Session"
2. **Position Cursor**: Click in input field (or auto-focused)
3. **Scan Code**: Point scanner at QR code, pull trigger
4. **Auto-Submit**: Scanner sends Enter key, check-in processes
5. **Next Scan**: Input clears automatically, ready for next

#### Manual Entry (Fallback)
If scanner fails or unavailable:
1. Type QR code value manually
2. Press Enter or click "Check In"
3. Works same as scanned input

---

## 🔄 Automatic Mode Detection

The component **automatically detects** the environment:

### Desktop Browser (Chrome, Firefox, Edge, Safari)
```
✅ Input field visible
✅ USB/Bluetooth scanner support
✅ Manual entry available
❌ Camera button hidden
ℹ️  Console: "BarcodeScanner unavailable. Non-mobile device? Using manual input mode."
```

### Salesforce Mobile App (iOS/Android)
```
✅ Input field visible
✅ Camera button visible
✅ Manual entry available (backup)
✅ Native camera scanning
ℹ️  Console: "Mobile scanner available"
```

### Experience Cloud Site (Desktop Browser)
```
✅ Input field visible
✅ USB/Bluetooth scanner support
✅ Manual entry available
❌ Camera button hidden
```

### Experience Cloud Site (Mobile Browser)
```
⚠️  Camera button MAY appear but won't work
✅ Manual entry works
✅ USB/Bluetooth scanner works (if supported by browser)
```

---

## 🆚 Comparison: Mobile vs Desktop

| Feature | Mobile Camera | Desktop USB Scanner |
|---------|--------------|---------------------|
| **Hardware** | Built-in camera | External scanner |
| **Cost** | Free (device camera) | $30-$300 USD |
| **Speed** | 2-3 seconds/scan | 0.5-1 second/scan |
| **Range** | 2-12 inches | 2-24 inches |
| **Ease of Use** | Very easy | Very easy |
| **Reliability** | Good (lighting dependent) | Excellent |
| **Best For** | Small events, mobile staff | High volume, fixed stations |
| **Setup Time** | None | 5 minutes initial |

---

## 📋 Which Mode to Use?

### Use Mobile Camera When:
- ✅ Small to medium events (< 200 attendees)
- ✅ Mobile check-in stations
- ✅ Roaming staff checking in attendees
- ✅ Budget constraints (no scanner purchase needed)
- ✅ Multiple check-in points
- ✅ Indoor events with good lighting

### Use USB/Bluetooth Scanner When:
- ✅ Large events (200+ attendees)
- ✅ High-volume check-in
- ✅ Fixed check-in stations
- ✅ Long scanning sessions (4+ hours)
- ✅ Need for maximum speed
- ✅ Multiple staff at same station

### Use Both When:
- ✅ Large events with multiple check-in points
- ✅ Fixed stations (USB) + roaming staff (mobile)
- ✅ Want maximum flexibility
- ✅ Need backup scanning method

---

## 🛠️ Technical Implementation

### Code Changes Made

#### JavaScript (`summitEventsQrCheckin.js`)

**New Import:**
```javascript
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
```

**New Properties:**
```javascript
myScanner;                // BarcodeScanner instance
scanButtonDisabled = false; // Mobile availability flag
```

**New Lifecycle Hook:**
```javascript
connectedCallback() {
    this.myScanner = getBarcodeScanner();
    if (this.myScanner == null || !this.myScanner.isAvailable()) {
        this.scanButtonDisabled = true;
        console.info('BarcodeScanner unavailable. Non-mobile device? Using manual input mode.');
    }
}
```

**New Method:**
```javascript
handleScanWithCamera() {
    // Opens native camera scanner
    // Supports QR and multiple barcode formats
    // Auto-processes scan result
}
```

**New Getter:**
```javascript
get isMobileDevice() {
    return !this.scanButtonDisabled;
}
```

#### HTML Template Updates

**Conditional Camera Button:**
```html
<template if:true={isMobileDevice}>
    <lightning-button
        label="Scan with Camera"
        icon-name="utility:scan"
        onclick={handleScanWithCamera}
    ></lightning-button>
</template>
```

**Dynamic Help Text:**
```html
<template if:true={isMobileDevice}>
    Tap the camera button below, use a USB scanner, or type the QR code
</template>
<template if:false={isMobileDevice}>
    Use a barcode scanner or type the QR code and press Enter
</template>
```

---

## 📱 Salesforce Mobile App Requirements

### For Camera Scanning to Work:

1. **Salesforce Mobile App Required**
   - iOS: Download from App Store
   - Android: Download from Google Play
   - Version: Latest recommended

2. **Camera Permissions**
   - User must grant camera access
   - Requested on first scan attempt

3. **Experience Cloud Access**
   - User must have access to Experience Cloud site
   - Component must be on a site page

4. **Session Active**
   - Must click "Start Scanning Session" first
   - Protects against accidental scans

---

## 🐛 Troubleshooting

### Issue: "BarcodeScanner unavailable" in Console

**This is NORMAL for desktop browsers!**
- ✅ Expected behavior on desktop computers
- ✅ Component still works with USB scanners
- ✅ Manual entry still works
- ℹ️ Just an informational message, not an error

**Solution:** No action needed. This confirms desktop mode is active.

---

### Issue: Camera button doesn't appear on mobile

**Possible causes:**
1. Not using Salesforce Mobile App (using mobile browser instead)
2. Old version of Salesforce Mobile App
3. Component not deployed properly

**Solution:**
1. Download/update Salesforce Mobile App
2. Open site within the mobile app
3. Verify component deployed successfully
4. Check browser console for errors

---

### Issue: Camera button appears but doesn't work

**Possible causes:**
1. Camera permissions denied
2. Using mobile browser (not mobile app)
3. Device doesn't support camera access

**Solution:**
1. Grant camera permissions in device settings
2. Open in Salesforce Mobile App (not browser)
3. Use manual entry as fallback

---

### Issue: Scans too slowly with camera

**Causes:**
- Low lighting conditions
- QR code too small or damaged
- Camera focus issues

**Solutions:**
- Improve lighting
- Use larger QR codes (2x2 inches minimum)
- Hold device steady during scan
- Consider USB scanner for high volume

---

### Issue: USB scanner not working on mobile

**Expected behavior!**
- Mobile devices don't support USB HID devices
- Use camera scanning on mobile
- USB scanners are for desktop only

---

## ✅ Testing Checklist

### Desktop Testing
- [ ] Component loads without errors
- [ ] "Start Session" works
- [ ] Input field accepts typed text
- [ ] Enter key triggers check-in
- [ ] USB scanner inputs codes correctly
- [ ] Scanner Enter key triggers check-in
- [ ] No camera button visible
- [ ] Console shows "BarcodeScanner unavailable" (expected)

### Mobile Testing (Salesforce Mobile App)
- [ ] Component loads in mobile app
- [ ] "Start Session" works
- [ ] Camera button visible
- [ ] Camera button opens scanner
- [ ] Camera permissions requested
- [ ] Scanning overlay appears
- [ ] QR code scans successfully
- [ ] Auto-check-in after scan
- [ ] Manual entry works as backup

### Both Modes
- [ ] Session management works
- [ ] Counter increments correctly
- [ ] Duration timer updates
- [ ] Success messages appear
- [ ] Error handling works
- [ ] Reset counter works
- [ ] End session works

---

## 📊 Best Practices

### Event Planning

**Small Event (< 50 people)**
- Use mobile camera scanning
- 1-2 staff with tablets/phones
- No additional hardware needed

**Medium Event (50-200 people)**
- Mix: USB scanner at main entrance
- Mobile camera for VIP/side entrance
- Manual entry as backup

**Large Event (200+ people)**
- USB scanners at all check-in stations
- Mobile camera for roaming staff
- Multiple fixed stations for speed

### Staffing Recommendations

**Desktop USB Scanner Stations:**
- 1 staff per 100-150 attendees/hour
- Fixed position at table/desk
- Wired power recommended

**Mobile Camera Scanning:**
- 1 staff per 50-75 attendees/hour
- Can move around freely
- Ensure device is charged

---

## 🎓 Training Staff

### Desktop Mode Training
1. Click "Start Scanning Session"
2. Point scanner at QR code
3. Pull trigger to scan
4. Wait for green confirmation
5. Scan next attendee

**Time needed:** 2 minutes

### Mobile Mode Training
1. Open site in Salesforce Mobile App
2. Click "Start Scanning Session"
3. Click "Scan with Camera"
4. Point camera at QR code
5. Hold steady until scan completes
6. Tap "Scan with Camera" for next

**Time needed:** 3 minutes

---

## 🔮 Future Enhancements

Possible future features:
- [ ] Continuous camera scanning mode
- [ ] Batch scanning support
- [ ] Offline scanning with sync
- [ ] Custom barcode formats
- [ ] Scan history/audit log
- [ ] Real-time attendance dashboard

---

## 📝 Summary

**The component now supports THREE input methods:**

1. **🎥 Mobile Camera** (Salesforce Mobile App only)
   - Native camera integration
   - No additional hardware
   - Good for mobile staff

2. **🔌 USB/Bluetooth Scanner** (Desktop only)
   - Fast and reliable
   - Best for high volume
   - Fixed check-in stations

3. **⌨️ Manual Entry** (Universal fallback)
   - Works everywhere
   - Type QR code value
   - Emergency backup

**Choose the method that best fits your event needs!**

---

## 🚀 Deployment

Deploy the updated component:

```bash
# Using SFDX
sfdx force:source:deploy -p force-app/main/default/lwc/summitEventsQrCheckin

# Using CumulusCI
cci task run deploy --path force-app/main/default/lwc/summitEventsQrCheckin
```

**Important:** Hard refresh browsers after deployment (Ctrl+Shift+R)

---

**The "BarcodeScanner unavailable" message is NORMAL on desktop devices! Your component now has full dual-mode support! 🎉**

