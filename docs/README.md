# Summit Events QR Check-In - Documentation Index

**Version 0.1** | Complete Documentation Suite

---

## 📚 Documentation Overview

This folder contains comprehensive documentation for the Summit Events QR Check-In System version 0.1. All documentation has been consolidated and organized for the production release.

---

## 📖 Available Documentation

### 1. **[V0.1 Release Notes](V0.1-RELEASE-NOTES.md)**
**Start here for a complete overview**

- What's new in Version 1.0
- Features matrix
- Complete component list
- Installation guide
- User guide (condensed)
- Technical specifications
- Browser compatibility
- Known issues & limitations
- Troubleshooting guide
- Future roadmap

**Audience:** Everyone  
**Length:** Comprehensive  
**Use when:** You want to understand everything about v1.0

---

### 2. **[User Guide](USER-GUIDE.md)**
**Complete instructions for check-in staff**

- Getting started
- Starting a check-in session
- Checking in registrants (camera & manual search)
- Managing sessions
- Undoing check-ins
- Understanding visual feedback
- Tips & best practices
- Frequently asked questions
- Quick reference card (printable)

**Audience:** Check-in staff, event coordinators  
**Length:** Detailed step-by-step  
**Use when:** Training staff or need operational procedures

---

### 3. **[Architecture Documentation](ARCHITECTURE.md)**
**Technical system design**

- System architecture diagrams
- Component relationships
- Data flow
- Apex methods reference
- LWC component structure
- Database interactions
- Security model

**Audience:** Developers, administrators, architects  
**Length:** Technical deep-dive  
**Use when:** Understanding system design or troubleshooting technical issues

---

### 4. **[Deployment Guide](../DEPLOYMENT_ORDER.md)**
**Step-by-step installation instructions**

Located in root: `DEPLOYMENT_ORDER.md`

- Pre-deployment checklist
- Phase 1: Deploy Apex classes
- Phase 2: Run tests
- Phase 3: Deploy static resources
- Phase 4: Deploy LWC component
- Phase 5: Configure permissions
- Phase 6: Add to page
- Phase 7: Verification & testing
- Rollback procedures
- Troubleshooting deployment issues

**Audience:** Administrators, DevOps  
**Length:** Detailed procedures  
**Use when:** Deploying to sandbox or production

---

## 🚀 Quick Start by Role

### **I'm a Check-In Staff Member**
→ Read: **[User Guide](USER-GUIDE.md)**  
→ Focus on: Getting Started, Checking In Registrants, Tips & Best Practices

### **I'm an Event Coordinator**
→ Read: **[User Guide](USER-GUIDE.md)** + **[V1.0 Release Notes](V0.1-RELEASE-NOTES.md)** (Training section)  
→ Focus on: Session management, troubleshooting, training your team

### **I'm Deploying This System**
→ Read: **[Deployment Guide](../DEPLOYMENT_ORDER.md)**  
→ Then: **[V1.0 Release Notes](V0.1-RELEASE-NOTES.md)** (Installation section)  
→ Focus on: Phased deployment, permissions, verification

### **I'm a Salesforce Administrator**
→ Read: **[V1.0 Release Notes](V0.1-RELEASE-NOTES.md)** (complete)  
→ Then: **[Deployment Guide](../DEPLOYMENT_ORDER.md)**  
→ Reference: **[Architecture](ARCHITECTURE.md)** for troubleshooting

### **I'm a Developer**
→ Read: **[Architecture](ARCHITECTURE.md)** (complete)  
→ Reference: **[V1.0 Release Notes](V0.1-RELEASE-NOTES.md)** (Technical Specifications)  
→ Code: Review Apex classes and LWC component in `force-app/`

---

## 🎯 Common Questions → Documentation

| Question | Document | Section |
|----------|----------|---------|
| How do I install this? | [Deployment Guide](../DEPLOYMENT_ORDER.md) | All phases |
| How do I use the camera? | [User Guide](USER-GUIDE.md) | Checking In Registrants |
| How do I search manually? | [User Guide](USER-GUIDE.md) | Method 2: Manual Search |
| How do I undo a check-in? | [User Guide](USER-GUIDE.md) | Undoing Check-Ins |
| What browsers are supported? | [V1.0 Release Notes](V0.1-RELEASE-NOTES.md) | Browser Support |
| What's the test coverage? | [V1.0 Release Notes](V0.1-RELEASE-NOTES.md) | Technical Specifications |
| How does the system work? | [Architecture](ARCHITECTURE.md) | System Architecture |
| Camera not working? | [User Guide](USER-GUIDE.md) | FAQ / Camera Questions |
| Deployment failed? | [Deployment Guide](../DEPLOYMENT_ORDER.md) | Troubleshooting |
| What's new in v1.0? | [V1.0 Release Notes](V0.1-RELEASE-NOTES.md) | What's New |

---

## 📁 Documentation Structure

```
docs/
├── README.md                    ← You are here (index)
├── V1.0-RELEASE-NOTES.md       ← Complete v1.0 overview
├── USER-GUIDE.md               ← Operational guide for staff
└── ARCHITECTURE.md             ← Technical documentation

Root:
└── DEPLOYMENT_ORDER.md         ← Installation guide
```

---

## 🆕 What's New in v1.0 Documentation

### Consolidation
- Merged 13 separate docs into 4 comprehensive guides
- Removed outdated feature-specific docs
- Eliminated redundancy and conflicts

### Additions
- Complete v1.0 release notes
- Comprehensive user guide with FAQ
- Quick reference cards for staff
- Detailed troubleshooting by role

### Improvements
- Clear documentation hierarchy
- Role-based reading paths
- Printable reference materials
- Consistent formatting and structure

---

## 📝 Documentation Maintenance

### Version History
- **v1.0** (October 2025) - Initial production release with consolidated docs

### Contributing
When updating documentation:
1. Update the appropriate document (don't create new files)
2. Maintain consistent formatting
3. Update this index if adding new documents
4. Version number in document headers

### Reporting Issues
Found an error or have a suggestion?
1. Check all 4 documents first (might be covered elsewhere)
2. Note document name and section
3. Submit feedback to your administrator

---

## 🎓 Training Resources

### For Staff Training
**Materials to use:**
1. [User Guide](USER-GUIDE.md) - Sections: Getting Started, Checking In, Tips
2. Print: Quick Reference Card (in User Guide)
3. Practice: Set up test data and practice scenarios

**Training Duration:** 15-30 minutes

### For Administrator Training
**Materials to use:**
1. [V1.0 Release Notes](V0.1-RELEASE-NOTES.md) - Complete read
2. [Deployment Guide](../DEPLOYMENT_ORDER.md) - Hands-on deployment
3. [Architecture](ARCHITECTURE.md) - For troubleshooting

**Training Duration:** 2-4 hours

---

## 🔗 Quick Links

**Main Documentation:**
- [📄 V1.0 Release Notes](V0.1-RELEASE-NOTES.md)
- [👥 User Guide](USER-GUIDE.md)
- [🏗️ Architecture](ARCHITECTURE.md)
- [🚀 Deployment Guide](../DEPLOYMENT_ORDER.md)

**External Resources:**
- [Summit Events App GitHub](https://github.com/SFDO-Community/Summit-Events-App)
- [Salesforce LWC Docs](https://developer.salesforce.com/docs/component-library)
- [jsQR Library](https://github.com/cozmo/jsQR)

---

**Version 0.1 Documentation - Complete and Production Ready ✅**

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

