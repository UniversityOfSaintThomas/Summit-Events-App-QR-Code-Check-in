# Summit Events QR Check-In Component

Complete documentation for the Summit Events QR Check-In Lightning Web Component.

---

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Quick Start](#quick-start)
4. [Installation](#installation)
5. [Usage Guide](#usage-guide)
6. [Technical Details](#technical-details)
7. [Troubleshooting](#troubleshooting)
8. [Development](#development)

---

## Overview

The Summit Events QR Check-In component provides a flexible, multi-method check-in system for event registrants using QR codes.

### Key Capabilities

- **Smart Camera Scanning** - Auto-detects device and uses appropriate camera
- **USB Scanner Support** - Works with standard USB/Bluetooth barcode scanners
- **Manual Entry** - Fallback option for typing QR codes
- **Session Management** - Track check-ins with counters and timers
- **Real-time Feedback** - Visual confirmation of check-in status

---

## Features

### Three Scanning Methods

1. **Smart Camera Button**
   - Automatically detects Salesforce Mobile App vs Desktop Browser
   - **Salesforce Mobile App**: Uses native camera scanner
   - **Desktop/Browser**: Uses jsQR library with webcam
   - Works on all modern browsers (Chrome, Firefox, Edge, Safari)

2. **USB/Bluetooth Scanner**
   - Standard keyboard emulation scanners
   - Fastest option (0.5-1 second per scan)
   - Best for high-volume events

3. **Manual Entry**
   - Type QR code value and press Enter
   - Universal fallback option
   - No additional hardware required

### Session Management

- Start/Stop/Reset scanning sessions
- Real-time counter tracking
- Session duration timer
- Professional check-in workflow

### Visual Feedback

- Green success cards for new check-ins
- Yellow warning cards for duplicate check-ins
- Red error cards for invalid QR codes
- Displays registrant name, event, and instance info

---

## Quick Start

### For Desktop Users

1. Open the check-in page
2. Click **"Start Scanning Session"**
3. Click **"Scan with Camera"**
4. Grant camera permission (first time only)
5. Point camera at QR code
6. Check-in processes automatically
7. Click **"Scan with Camera"** for next registrant

### For Mobile App Users

1. Open Salesforce Mobile App
2. Navigate to check-in page
3. Click **"Start Scanning Session"**
4. Click **"Scan with Camera"**
5. Native scanner opens automatically
6. Point phone at QR code
7. Click **"Scan with Camera"** for next registrant

### For USB Scanner Users

1. Connect USB scanner to computer
2. Click **"Start Scanning Session"**
3. Click in the input field
4. Point scanner at QR code and pull trigger
5. Check-in processes automatically
6. Scan next QR code

---

## Installation

### Prerequisites

- Salesforce org with Summit Events App installed
- Lightning Experience or Experience Cloud site
- Modern web browser (Chrome 83+, Firefox, Edge, Safari 11+)

### Deployment Steps

#### 1. Deploy Static Resources

```bash
sfdx force:source:deploy -p force-app/main/default/staticresources
```

This deploys:
- `jsQR.js` - QR code detection library (127KB)

#### 2. Deploy Apex Classes

```bash
sfdx force:source:deploy -p force-app/main/default/classes
```

This deploys:
- `summitEventsCheckin.cls` - Check-in logic
- `summitEventsCheckinTest.cls` - Test coverage

#### 3. Deploy LWC Component

```bash
sfdx force:source:deploy -p force-app/main/default/lwc/summitEventsQrCheckin
```

This deploys:
- `summitEventsQrCheckin.js` - Component controller
- `summitEventsQrCheckin.html` - Template
- `summitEventsQrCheckin.css` - Styles
- `summitEventsQrCheckin.js-meta.xml` - Metadata

#### 4. Or Deploy Everything

```bash
sfdx force:source:deploy -p force-app/main/default
```

#### 5. Run Tests

```bash
sfdx force:apex:test:run -n summitEventsCheckinTest -r human
```

Expected: All tests pass with 100% coverage

---

## Usage Guide

### Component Configuration

#### In Experience Builder

1. Add component to page
2. Configure properties:
   - **Card Title**: Default "Event Check-In" (customizable)

#### In Lightning App Builder

1. Drag component to page
2. Available on Record Pages, App Pages, Home Pages
3. Works on Summit Events Registration record pages

### Session Workflow

#### Starting a Session

1. Click **"Start Scanning Session"**
2. Counter initializes to 0
3. Session timer starts
4. Input field becomes active
5. Camera buttons become available

#### During a Session

- **Scan Count**: Tracks successful check-ins
- **Session Duration**: Shows elapsed time
- **Session Active**: Green indicator shows active status
- **Auto-focus**: Input field automatically focused after each scan

#### Ending a Session

Click **Session** menu → **End Session**
- Shows summary: "Checked in X registrants in Y time"
- Returns to start screen
- All counters reset

#### Resetting Counter

Click **Session** menu → **Reset Counter**
- Counter resets to 0
- Session continues
- Timer continues

### Check-In Process

#### Successful Check-In

Display shows:
- ✅ Success icon
- "Check-in successful!"
- Registrant name
- Event name
- Instance title
- Green background

#### Already Checked In

Display shows:
- ⚠️ Warning icon
- "This registrant is already checked in"
- Registrant name
- Yellow background

#### Invalid QR Code

Display shows:
- ❌ Error icon
- "No registration found with this QR code"
- Red background

---

## Technical Details

### Architecture

#### Component Structure

```
summitEventsQrCheckin/
├── summitEventsQrCheckin.js          # Controller logic
├── summitEventsQrCheckin.html        # UI template
├── summitEventsQrCheckin.css         # Styles
├── summitEventsQrCheckin.js-meta.xml # Metadata
└── __tests__/
    └── summitEventsQrCheckin.test.js # Jest tests
```

#### Apex Classes

```
classes/
├── summitEventsCheckin.cls           # Check-in logic
├── summitEventsCheckin.cls-meta.xml
├── summitEventsCheckinTest.cls       # Test coverage
└── summitEventsCheckinTest.cls-meta.xml
```

#### Static Resources

```
staticresources/
├── jsQR.js                           # QR detection library
└── jsQR.resource-meta.xml
```

### Device Detection Logic

```javascript
// Auto-detects device type in handleBrowserCameraScan()
const isSalesforceMobile = this.myScanner != null && this.myScanner.isAvailable();

if (isSalesforceMobile) {
    // Salesforce Mobile App detected
    this.handleScanWithCamera();  // Use native scanner
} else {
    // Desktop/Browser detected
    // Use jsQR with getUserMedia camera
}
```

### Camera Scanning (Desktop)

**Technology**: jsQR library from static resource  
**API**: HTML5 getUserMedia  
**Process**:
1. Request camera access
2. Display video stream
3. Capture frames to canvas (every 100ms)
4. Process with jsQR library
5. Detect QR code
6. Process check-in

### Camera Scanning (Mobile App)

**Technology**: Salesforce BarcodeScanner API  
**Process**:
1. Call `getBarcodeScanner()`
2. Configure barcode types
3. Call `beginCapture()`
4. Native scanner opens
5. OS handles scanning
6. Return QR code value
7. Process check-in

### Data Flow

```
QR Code Scan
    ↓
qrCodeInput value set
    ↓
handleCheckIn() called
    ↓
checkInRegistrant Apex method
    ↓
Query Summit_Events_Registration__c by QR code
    ↓
Update Status to "Attended"
    ↓
Return CheckinResult
    ↓
Display result card
    ↓
Increment counter
    ↓
Show success toast
```

### Browser Compatibility

| Browser | Desktop Camera | Mobile App | USB Scanner |
|---------|---------------|------------|-------------|
| Chrome 83+ | ✅ Yes | ✅ Yes | ✅ Yes |
| Firefox | ✅ Yes | ✅ Yes | ✅ Yes |
| Edge 83+ | ✅ Yes | ✅ Yes | ✅ Yes |
| Safari 11+ | ✅ Yes | ✅ Yes | ✅ Yes |
| IE 11 | ❌ No | ❌ No | ✅ Yes |

---

## Troubleshooting

### Common Issues

#### Camera Permission Denied

**Symptoms**: "Please grant camera permissions" error

**Solutions**:
1. Click camera icon in browser address bar
2. Select "Allow" for camera access
3. Refresh the page
4. Try scanning again

**Chrome**: 🎥 icon → Permissions → Camera → Allow  
**Firefox**: 🔒 icon → Permissions → Camera → Allow  
**Safari**: Safari → Preferences → Websites → Camera → Allow

#### Camera Opens But Doesn't Scan

**Possible Causes**:
- Poor lighting conditions
- QR code too small or damaged
- QR code not in focus

**Solutions**:
- Improve lighting
- Move QR code closer/farther from camera
- Use larger QR codes (2x2 inches minimum)
- Clean camera lens if blurry
- Try USB scanner instead

#### "Scanner is Still Loading"

**Cause**: jsQR library hasn't finished loading

**Solution**:
1. Wait 2-3 seconds
2. Try clicking "Scan with Camera" again
3. Check internet connection

#### USB Scanner Not Working

**Check**:
1. Scanner is properly connected
2. Scanner configured for keyboard emulation
3. Scanner sends Enter key after scan
4. Click in input field before scanning

#### No Camera Button Visible

**Causes**:
- Component not deployed
- Browser cache needs clearing
- jsQR static resource not deployed

**Solutions**:
1. Verify deployment completed
2. Hard refresh (Ctrl+Shift+R)
3. Check browser console for errors
4. Redeploy component

---

## Development

### Local Development Setup

```bash
# Clone repository
git clone <repository-url>
cd Summit-Evetns-App-Checkin

# Install dependencies
npm install

# Run Jest tests
npm test

# Deploy to scratch org
sfdx force:source:push

# Run Apex tests
sfdx force:apex:test:run -n summitEventsCheckinTest
```

### Running Tests

#### Jest Tests (LWC)

```bash
npm run test:unit
```

Expected output: All tests pass

#### Apex Tests

```bash
sfdx force:apex:test:run -n summitEventsCheckinTest -r human
```

Expected output: 100% code coverage

### Key Configuration

#### Component Metadata

```xml
<LightningComponentBundle>
    <apiVersion>64.0</apiVersion>
    <isExposed>true</isExposed>
    <targets>
        <target>lightning__AppPage</target>
        <target>lightning__RecordPage</target>
        <target>lightning__HomePage</target>
        <target>lightningCommunity__Page</target>
        <target>lightningCommunity__Default</target>
    </targets>
    <targetConfigs>
        <targetConfig targets="lightningCommunity__Default">
            <property name="title" type="String" label="Card Title" 
                      default="Event Check-In"/>
        </targetConfig>
    </targetConfigs>
</LightningComponentBundle>
```

#### Static Resource

```xml
<StaticResource>
    <cacheControl>Public</cacheControl>
    <contentType>application/javascript</contentType>
    <description>jsQR library for QR code detection</description>
</StaticResource>
```

### Extending the Component

#### Add New Scanning Method

1. Create new handler method in JS
2. Add button in HTML template
3. Implement scanning logic
4. Call `handleCheckIn()` with scanned value

#### Add Custom Fields to Result

1. Update `CheckinResult` wrapper class in Apex
2. Query additional fields in `checkInRegistrant()`
3. Update HTML template to display new fields

#### Customize Session Management

1. Modify `handleStartSession()` for custom initialization
2. Add new session properties (tracked)
3. Add UI elements in HTML for new features

---

## Additional Resources

### Support

- **Summit Events App**: [GitHub Repository](https://github.com/SFDO-Community/Summit-Events-App)
- **Issues**: Submit via GitHub Issues
- **Community**: Salesforce Community Groups

### Related Documentation

- Salesforce Lightning Web Components Developer Guide
- BarcodeScanner API Documentation
- jsQR Library Documentation

---

## Version History

### Current Version
- Smart device detection
- jsQR static resource integration
- Session management
- Multiple scanning methods
- Professional UI/UX

---

## License

This component is part of the Summit Events App and follows its licensing.

---

**For questions or support, please refer to the Summit Events App community.**

