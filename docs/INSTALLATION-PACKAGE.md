# Installation Guide - Unlocked Package

## For Administrators and End Users

This guide shows how to install the Summit Events QR Check-In component in your Salesforce org using the unlocked package from GitHub Releases.

---

## Prerequisites

Before installing, ensure you have:

### Required
- ✅ **Summit Events App** installed and configured
  - Get it from: [SFDO-Community/Summit-Events-App](https://github.com/SFDO-Community/Summit-Events-App)
  - This must be installed FIRST
- ✅ **Salesforce API version 54.0+** (Spring '22 or later)
- ✅ **System Administrator** or equivalent permissions

### Recommended (for best experience)
- ✅ **Lightning Web Security enabled** - For browser camera scanning
  - See [LWS Enablement Guide](./LWS-ENABLEMENT-GUIDE.md) after installation

---

## Installation Steps

### Step 1: Get the Latest Package

1. Go to the **[Releases Page](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/releases)**
2. Find the **latest release** (at the top)
3. Read the release notes to see what's new
4. Copy the **Package Installation URL**
   - Look for a URL like: `https://login.salesforce.com/packaging/installPackage.apexp?p0=04t...`

### Step 2: Install the Package

1. **Paste the installation URL** into your browser
2. **Log in** to your Salesforce org (if not already logged in)
3. You'll see the package installation page

### Step 3: Installation Wizard

#### Screen 1: Confirm Package Details
- Review package name: "Summit Events Check-In" (or similar)
- Review version number
- Click **Continue**

#### Screen 2: Approve Third-Party Access
- Review the message about third-party access
- Check: "Yes, grant access to these third-party websites"
- Click **Continue**

#### Screen 3: Choose Security Settings
Select who can access the package:

- **Option 1 (Recommended for initial install):** "Install for Admins Only"
  - Test functionality first
  - Grant broader access later via permission sets
  
- **Option 2:** "Install for All Users"
  - Use if you're ready for full deployment
  
- **Option 3:** "Install for Specific Profiles"
  - Choose which profiles get access
  
Click **Install**

#### Screen 4: Approve Package API Access
- Review which Apex classes will have access
- Click **Continue**

### Step 4: Wait for Installation

- Installation typically takes 5-10 minutes
- You'll receive an email when complete
- Or refresh the page to check status

### Step 5: Post-Installation Setup

Once installed:

1. **Enable Lightning Web Security** (for camera scanning)
   - Setup → Session Settings
   - Enable "Lightning Web Security for Lightning Experience"
   - Enable "Use Lightning Web Security for Lightning components in Experience Builder sites"
   - See [LWS Enablement Guide](./LWS-ENABLEMENT-GUIDE.md) for details

2. **Assign Permissions** (if needed)
   - Setup → Permission Sets
   - Find "Summit Events Registrant Custom" or similar
   - Assign to appropriate users

3. **Add to Experience Cloud Site** (if using)
   - Experience Builder → Edit Site
   - Add component to desired page
   - Configure visibility settings

4. **Test the Component**
   - Navigate to the component
   - Try manual search first
   - Test camera scanning (if LWS enabled)

---

## Verification

### Test the Installation

1. **Open Salesforce**
2. **Navigate to Summit Events**
3. **Find a Registration record** with QR code
4. **Open the Check-In component**
5. **Try checking in:**
   - Start a scanning session
   - Use manual search to find a registrant
   - Confirm check-in works

### Check Installed Components

Setup → Installed Packages → Find "Summit Events Check-In"

Should show:
- Version number
- Installation date
- Components included:
  - Apex Classes (2)
  - Lightning Web Components (1)
  - Permission Sets (1)
  - Static Resources (1)

---

## Upgrading to a Newer Version

### When a New Version is Available

1. Go to [Releases Page](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/releases)
2. Check for newer version than currently installed
3. Read release notes for:
   - New features
   - Bug fixes
   - Breaking changes
   - Migration notes

### Upgrade Process

1. **Back up your configuration** (if you have custom settings)
2. Copy the **new package installation URL**
3. Follow the same installation steps as above
4. The system will recognize it as an upgrade
5. Choose "Upgrade" when prompted
6. Test after upgrade completes

### Version Checking

Setup → Installed Packages → Summit Events Check-In → View version number

Compare with [latest release](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/releases)

---

## Installation in Different Org Types

### Production Org
```
✅ Recommended: Install for Admins Only first
✅ Test thoroughly
✅ Enable for all users after validation
```

### Sandbox
```
✅ Test ground for new versions
✅ Install for All Users to mirror production
✅ Test upgrades here first
```

### Developer Org
```
✅ Install for All Users
✅ Experiment with features
✅ Test customizations
```

### Scratch Org (Developers)
```
❌ Don't use package installation
✅ Use CumulusCI instead
✅ See Developer Setup Guide
```

---

## Troubleshooting Installation

### Installation Fails

**Error: "This package can't be installed"**
- ✅ Check Summit Events App is installed first
- ✅ Verify Salesforce version (54.0+)
- ✅ Check you have System Administrator permissions

**Error: "Component version X.X is not compatible"**
- ✅ Update Summit Events App to latest version
- ✅ Check release notes for compatibility requirements

**Error: "Installation timeout"**
- ✅ Retry installation
- ✅ Check Salesforce status at trust.salesforce.com
- ✅ Contact Salesforce support if persistent

### Post-Installation Issues

**Component not visible**
- ✅ Check permission sets are assigned
- ✅ Verify app is added to Experience Cloud site (if applicable)
- ✅ Check user has access to Summit Events records

**Camera not working**
- ✅ Enable Lightning Web Security (see [LWS Guide](./LWS-ENABLEMENT-GUIDE.md))
- ✅ Check browser compatibility (Chrome, Firefox, Edge)
- ✅ Verify HTTPS connection
- ✅ See [Camera Troubleshooting](./CAMERA-TROUBLESHOOTING.md)

**Tests fail during installation**
- ✅ Check Summit Events App test data is present
- ✅ Verify namespace settings
- ✅ Review installation logs

---

## Uninstalling (If Needed)

### Before Uninstalling

⚠️ **Warning:** Uninstalling removes all functionality. Check-in history in Summit Events records will remain.

### Uninstall Steps

1. Setup → Installed Packages
2. Find "Summit Events Check-In"
3. Click **Uninstall**
4. Confirm uninstallation
5. Wait for completion (5-10 minutes)

### After Uninstalling

- Check-in component removed from all pages
- Permission sets removed
- Apex classes removed
- Static resources removed
- **Check-in data in Summit Events records remains intact**

---

## Getting Help

### Installation Issues

1. **Check Release Notes**
   - [Latest Release](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/releases)
   - Look for known issues

2. **Review Documentation**
   - [Installation Guide](./INSTALLATION-PACKAGE.md) (this document)
   - [LWS Enablement Guide](./LWS-ENABLEMENT-GUIDE.md)
   - [Camera Troubleshooting](./CAMERA-TROUBLESHOOTING.md)

3. **Open an Issue**
   - [GitHub Issues](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/issues)
   - Include:
     - Salesforce version
     - Package version attempting to install
     - Error message (full text)
     - Installation logs (if available)

4. **Community Support**
   - Check existing issues for solutions
   - Ask in Salesforce community forums

---

## Best Practices

### Installation Planning

- ✅ **Install in sandbox first** - Test before production
- ✅ **Read release notes** - Understand what's changing
- ✅ **Schedule maintenance window** - For production installations
- ✅ **Communicate to users** - Let them know about new features
- ✅ **Train staff** - Before major events

### Post-Installation

- ✅ **Enable LWS immediately** - For best camera experience
- ✅ **Test with real data** - Use actual registrations
- ✅ **Document customizations** - For future upgrades
- ✅ **Monitor usage** - Check adoption and feedback

### Staying Current

- ✅ **Subscribe to releases** - Get notifications from GitHub
- ✅ **Review changelogs** - Before each upgrade
- ✅ **Test new versions** - In sandbox first
- ✅ **Keep Summit Events App updated** - Maintain compatibility

---

## Version History

Track your installations:

| Date | Version | Notes |
|------|---------|-------|
| _Your Date_ | _Version_ | Initial install |
| _Your Date_ | _Version_ | Upgraded for camera fixes |

---

## Next Steps After Installation

1. ✅ **[Enable Lightning Web Security](./LWS-ENABLEMENT-GUIDE.md)** - For camera scanning
2. ✅ **[Read Quick Start Guide](./QUICK-START.md)** - Learn check-in methods
3. ✅ **[Train staff with User Guide](./USER-GUIDE.md)** - Full instructions
4. ✅ **Test at small event** - Validate before major event
5. ✅ **Gather feedback** - Improve workflows

---

## Resources

### Package & Installation
- **[Latest Release](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/releases)** - Download package
- **[All Releases](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/releases)** - Version history
- **[Repository](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in)** - Source code

### Documentation
- [LWS Enablement Guide](./LWS-ENABLEMENT-GUIDE.md) - Enable camera
- [Quick Start Guide](./QUICK-START.md) - Get started
- [User Guide](./USER-GUIDE.md) - Complete instructions
- [Camera Troubleshooting](./CAMERA-TROUBLESHOOTING.md) - Fix issues

### Dependencies
- [Summit Events App](https://github.com/SFDO-Community/Summit-Events-App) - Required dependency

### Support
- [Open an Issue](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/issues) - Report bugs
- [View Issues](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/issues) - Check known issues

---

## Summary

**Quick Installation:**
1. Go to [Releases](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/releases)
2. Copy installation URL
3. Paste in browser (logged into Salesforce)
4. Follow installation wizard
5. Enable Lightning Web Security
6. Test and use!

**Questions?** See the [documentation index](./README.md) or [open an issue](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/issues).

