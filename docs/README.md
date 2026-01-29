# Summit Events QR Check-In - Documentation

**Lightning Web Component for Summit Events App**

Complete check-in solution with QR code scanning, manual search, and context-aware deployment.

**Status:** ✅ Production Ready (v2.0 - January 2026)

---

## 📚 Documentation Index

### Getting Started (Essential)

- **[Quick Start Guide](QUICK-START.md)** - Get started in 2 minutes
- **[User Guide](USER-GUIDE.md)** - Complete user instructions for check-in staff
- **[Installation Guide](INSTALLATION-PACKAGE.md)** - Package installation instructions

### Administrator Guides

- **[Camera Troubleshooting](CAMERA-TROUBLESHOOTING.md)** - Resolve camera access issues
- **[LWS Enablement Guide](LWS-ENABLEMENT-GUIDE.md)** - Enable browser camera scanning (desktop only)

### Developer Resources

- **[Developer Setup](DEVELOPER-SETUP.md)** - Development environment with CumulusCI
- **[Architecture](ARCHITECTURE.md)** - Technical architecture and component design
- **[Unit Test Setup](UNIT-TEST-SETUP.md)** - Jest testing configuration and test suite (LWC)
- **[Apex Test Coverage](APEX-TEST-COVERAGE.md)** - Apex unit test suite and coverage guide

### Archive

Historical documentation, milestone reports, and deprecated guides are in `/docs/archive/`

---

## 🚀 Key Features (Current Production Version)

### 1. Context-Aware Deployment ✅
Automatically detects when placed on a Summit Events Instance record page.

**On Instance Record Page:**
- ✅ Auto-loads instance from page context
- ✅ "Start Scanning Session" button ready immediately
- ✅ No manual date/instance selection needed

**On App/Home/Community Pages:**
- ✅ Shows date picker and instance dropdown
- ✅ Select event and instance manually
- ✅ Works anywhere in Salesforce

### 2. Multi-Platform Scanning ✅

**Salesforce Mobile App:**
- Native barcode scanner (best performance)
- Automatically used when available
- Supports all barcode types

**Desktop Browser:**
- jsQR-based camera scanner
- Optimized for fast QR detection (~0.5 seconds)
- Requires Lightning Web Security (LWS) enabled
- Works in Chrome, Firefox, Edge, Safari

**Manual Search:**
- Search by first name, last name, or email
- Paginated results (5 per page)
- Available on all platforms

### 3. Production-Optimized Performance ✅

**Desktop Camera:**
- 7x faster QR detection (540ms average)
- Forced 640×480 resolution for optimal speed
- 1-second scan interval for reliability
- Auto-scrolls to results on mobile

**Mobile Scanner:**
- Native Salesforce scanner prioritized
- Instant detection on mobile devices
- Seamless experience in mobile app

### 4. Session Management ✅
- Start/Stop/Reset session controls
- Live scan counter
- Session duration tracking
- Total attended vs registered count

### 5. Check-In Workflow ✅
- Two-step confirmation process
- Shows registrant details before check-in
- Undo check-in capability
- Already-checked-in detection
- Real-time count updates
- **USB Scanner:** Keyboard input mode
- **Manual Search:** Name and email lookup with pagination

### Real-Time Session Management
- Configurable check-in status values
- Live attendance counters (attended/registered)
- Session tracking with start time
- Undo check-in functionality
- Duplicate detection and warnings

---

## 📦 Installation

### Package Installation (Recommended)
Install the latest unlocked package from GitHub Releases:

👉 **[View Latest Release](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/releases)**

See [Installation Guide](INSTALLATION-PACKAGE.md) for complete instructions.

### Developer Setup
For development with CumulusCI:

See [Developer Setup Guide](DEVELOPER-SETUP.md) for complete workflow.

---

## 🎯 Quick Start

### For Administrators

1. **Install the package** from GitHub Releases
2. **Assign permissions** - Summit Events Registrant Custom permission set
3. **Enable LWS** (optional, for browser camera) - Setup → Session Settings
4. **Add to page layouts** - Instance record pages, app pages, or home pages

### For End Users

1. **Navigate to check-in location:**
   - Summit Events Instance record page, OR
   - App page / Home page with component

2. **Start scanning session:**
   - On instance page: Click "Start Scanning Session"
   - On other pages: Select date → Select instance → Start session

3. **Check in attendees:**
   - Scan QR code (mobile or browser camera)
   - Use USB scanner
   - Search manually by name/email

---

## 🔧 Component Configuration

### Deployment Options

#### Option 1: Instance Record Page (Recommended)
Place component directly on Summit Events Instance record page for automatic instance detection.

**Benefits:**
- No date/instance selection needed
- Cleaner UI for check-in staff
- Faster workflow

**Setup:**
1. Navigate to any Summit Events Instance record
2. Click gear icon → Edit Page
3. Drag "Summit Events QR Check-In" component onto page
4. Save and activate

#### Option 2: App or Home Page
Place component on app page or home page for manual instance selection.

**Benefits:**
- Single location for all events
- Flexibility to switch between instances
- Central check-in hub

**Setup:**
1. Lightning App Builder → New App Page
2. Add "Summit Events QR Check-In" component
3. Configure title and check-in status
4. Save and activate

### Component Properties

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| **Card Title** | String | Title displayed on component card | "Event Check-In" |
| **Check-In Status Value** | String | Status value to set when checking in | "Attended" |

---

## 📱 Mobile Support

The component fully supports the Salesforce Mobile App:
- ✅ Responsive design (Large and Small form factors)
- ✅ Native barcode scanner on mobile devices
- ✅ Touch-optimized interface
- ✅ Works on Instance record pages in mobile app

---

## 🎥 Camera Scanning

### Browser Camera (Desktop)
**Requires Lightning Web Security (LWS)** to be enabled.

**To Enable:**
1. Setup → Session Settings
2. Enable "Use Lightning Web Security for Lightning components in Experience Builder sites"
3. Save

See [LWS Enablement Guide](LWS-ENABLEMENT-GUIDE.md) for details.

### Mobile Camera
Works automatically on Salesforce Mobile App (no LWS needed).

### Fallback Options
If camera isn't available:
- USB barcode scanner (keyboard input mode)
- Manual search by name and email

---

## 📊 Architecture Highlights

- **Apex-First Design:** Single server round-trip loads all instance data
- **LWC Reactivity:** Proper object spreading for reactive updates
- **URL-Based Detection:** Reliable record ID detection from browser URL
- **Modern UI Patterns:** Modals, toasts, drag-drop reordering
- **Comprehensive Error Handling:** User-friendly error messages

See [Architecture](ARCHITECTURE.md) for technical details.

---

## 🐛 Troubleshooting

### Camera Not Working
See [Camera Troubleshooting](CAMERA-TROUBLESHOOTING.md) for complete guide.

**Quick Checks:**
- Is LWS enabled? (Setup → Session Settings)
- Is page accessed via HTTPS?
- Is browser supported? (Chrome, Firefox, Edge, Safari)

### Component Not Detecting Instance
**Symptoms:** Shows date/instance picker on instance record page

**Solutions:**
1. Hard refresh browser (Ctrl+Shift+R)
2. Re-add component to page layout
3. Check browser console for errors
4. Verify component meta.xml includes `summit__Summit_Events_Instance__c` in objects list

### Check-In Not Working
- Verify user has "Summit Events Registrant Custom" permission set
- Check instance has registrations
- Verify QR code matches registration in this instance

---

## 📋 Support & Contributing

- **Issues:** [GitHub Issues](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/issues)
- **Documentation:** `/docs/` folder in repository
- **Developer Guide:** [Developer Setup](DEVELOPER-SETUP.md)

---

## 📄 License

See repository LICENSE file for details.

---

## 🙏 Credits

Built with Summit Events App for Salesforce Education Cloud.
