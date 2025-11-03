# Lightning Web Security Enablement Guide

## Executive Summary

**Camera scanning works when Lightning Web Security (LWS) is enabled.**

This guide shows Salesforce administrators how to enable LWS to unlock browser camera functionality in the Summit Events Check-In component.

## Installation

**Install the latest unlocked package from GitHub:**

👉 **[View Latest Release & Installation Instructions](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/releases)**

Once installed, follow this guide to enable camera scanning.

---

## What is Lightning Web Security?

**Lightning Web Security (LWS)** is Salesforce's modern security framework that:
- ✅ Replaces the older "Locker Service" security model
- ✅ Provides better performance
- ✅ Supports more standard browser APIs (including camera)
- ✅ Uses modern JavaScript security features
- ✅ Is recommended by Salesforce for all new implementations

**Key Fact:** With LWS enabled, `navigator.mediaDevices` (camera API) becomes available to Lightning Web Components.

---

## Prerequisites

Before enabling LWS, verify:
- [ ] You have System Administrator or equivalent permissions
- [ ] You're running Salesforce version 244 (Spring '22) or later
- [ ] You've tested in a sandbox environment first (recommended)
- [ ] You've reviewed any third-party packages for LWS compatibility

---

## Step-by-Step: Enable Lightning Web Security

### Step 1: Access Session Settings

1. Log into Salesforce as System Administrator
2. Click the **gear icon** (⚙️) in the top right
3. Select **Setup**
4. In the Quick Find box, type: **Session Settings**
5. Click **Session Settings**

### Step 2: Enable Lightning Web Security

Scroll down to the **Lightning Web Security** section:

#### For Lightning Experience (Internal Users):
1. Check: ☑️ **"Enable Lightning Web Security for Lightning Experience"**
2. This enables LWS for internal Salesforce users

#### For Experience Cloud (External Users):
1. Check: ☑️ **"Use Lightning Web Security for Lightning components in Experience Builder sites"**
2. This enables LWS for Experience Cloud sites (where check-in component is typically used)

### Step 3: Save Changes

1. Click **Save** at the bottom of the page
2. Wait for confirmation message
3. Changes take effect immediately (no deployment needed)

### Step 4: Clear Browser Cache (Recommended)

For best results:
1. Close all Salesforce tabs
2. Clear browser cache
3. Restart browser
4. Log back into Salesforce

---

## Verification Steps

### For CumulusCI Users

If using CumulusCI for development:
```bash
# Create scratch org with everything configured
cci flow run dev_org --org dev

# Open org
cci org browser dev

# Navigate to Setup → Session Settings → Enable LWS
# Then test camera scanning
```

See [Developer Setup Guide](./DEVELOPER-SETUP.md) for complete CumulusCI workflow.

### Test 1: Check Console Logs

1. Open your Experience Cloud site with the check-in component
2. Press **F12** to open Developer Tools
3. Go to **Console** tab
4. Look for these messages when page loads:

```
🔍 Checking camera support...
  - navigator.mediaDevices: true  ✅
  - getUserMedia: true            ✅
✅ Camera support detected
```

### Test 2: Try Camera Scanning

1. Click **"Start Scanning Session"**
2. Select an event date and instance
3. Click **"Scan with Camera"**
4. Your browser should prompt for camera permission
5. Grant permission
6. Camera should open successfully! 🎉

Expected behavior:
- Browser shows camera permission prompt
- After allowing, camera preview appears
- QR codes in camera view are detected and processed

### Test 3: Verify Different Browsers

Test camera scanning in:
- ✅ Chrome 53+ (recommended)
- ✅ Firefox 36+
- ✅ Edge 79+
- ✅ Safari 11+

All should work with LWS enabled.

---

## Before vs After LWS

### Before (Locker Service):

**Desktop Browser:**
```
❌ Camera blocked
✅ Manual search works
✅ USB scanner works
```

**Mobile Web Browser:**
```
❌ Camera blocked
✅ Manual search works
```

**Salesforce Mobile App:**
```
✅ Native scanner works
✅ Manual search works
```

### After (Lightning Web Security):

**Desktop Browser:**
```
✅ Camera works! 🎉
✅ Manual search works
✅ USB scanner works
```

**Mobile Web Browser:**
```
✅ Camera works! 🎉
✅ Manual search works
```

**Salesforce Mobile App:**
```
✅ Native scanner works
✅ Manual search works
```

---

## Rollout Strategy

### Recommended Approach: Phased Rollout

#### Phase 1: Sandbox Testing (1-2 weeks)
1. Enable LWS in sandbox
2. Test check-in component
3. Test all other custom components
4. Test managed packages
5. Document any issues

#### Phase 2: Pilot Production (1 week)
1. Enable LWS in production during low-usage period
2. Monitor for 1 week
3. Test check-in at a small event
4. Gather user feedback

#### Phase 3: Full Rollout
1. Train staff on camera scanning
2. Announce camera availability
3. Update training materials
4. Monitor usage and issues

### Conservative Approach: Enable for Experience Cloud Only

If you're concerned about impact on internal users:

1. Enable only: **"Use Lightning Web Security for Lightning components in Experience Builder sites"**
2. Leave Lightning Experience LWS disabled initially
3. This gives you camera scanning for check-in while minimizing internal impact
4. Enable Lightning Experience LWS later after confidence builds

---

## Potential Issues & Solutions

### Issue 1: Third-Party Packages Break

**Symptoms:**
- Managed package components show errors
- Custom functionality stops working

**Solution:**
1. Check with package vendor for LWS compatibility
2. Update packages to LWS-compatible versions
3. If not available, disable LWS and use alternative check-in methods

### Issue 2: Custom Aura Components Break

**Symptoms:**
- Older Aura components show errors
- Console shows JavaScript errors

**Solution:**
1. Review Aura components for compatibility
2. Update to use LWS-safe patterns
3. Consider migrating to LWC
4. See: [Salesforce LWS Migration Guide](https://help.salesforce.com/s/articleView?id=sf.lws_migrate.htm&type=5)

### Issue 3: Browser Still Blocks Camera

**Symptoms:**
- LWS enabled but camera still doesn't work
- Error: "Camera API not available"

**Possible Causes:**
1. **Browser too old** - Update to Chrome 53+, Firefox 36+, Edge 79+, Safari 11+
2. **Not HTTPS** - Verify URL starts with https://
3. **Camera permissions denied** - Check browser settings
4. **No camera on device** - Use alternative method
5. **Browser cache** - Clear cache and reload

**Solution Steps:**
1. Verify HTTPS connection
2. Update browser to latest version
3. Check browser camera permissions
4. Clear cache and reload page
5. Try different browser

### Issue 4: Users Confused About New Feature

**Symptoms:**
- Staff doesn't know camera is available
- Still using only manual search

**Solution:**
1. Send announcement about camera feature
2. Update training materials
3. Add visible instructions near component
4. Demo at next staff meeting
5. Update help documentation

---

## Rollback Plan

If you need to disable LWS:

### Quick Rollback:
1. Setup → Session Settings
2. Uncheck LWS options
3. Save
4. Camera scanning stops working
5. Component falls back to manual search and mobile app scanner

### No Data Loss:
- Disabling LWS doesn't affect any data
- All check-ins are preserved
- Component continues working with fallback methods

---

## Communication Templates

### Email to Staff:

**Subject:** New Feature: Camera Scanning for Event Check-In

Hi Team,

Great news! We've enabled a new feature that allows you to use your computer's webcam or phone's camera to scan QR codes for event check-in.

**What's New:**
- Desktop computers can now use webcams for QR scanning
- Mobile browsers can use phone cameras for QR scanning
- Faster check-in process

**How to Use:**
1. Click "Start Scanning Session"
2. Click "Scan with Camera"
3. Allow camera access when prompted
4. Point camera at QR code

**Backup Options:**
- Manual search still available
- Salesforce Mobile App still works
- USB scanners still work

Questions? See the [Quick Start Guide](./QUICK-START.md)

Thanks!

### Sign at Check-In Station:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   EVENT CHECK-IN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📷 NEW: Camera Scanning Available!

Click "Scan with Camera" to use
your webcam or phone camera

OR

🔍 Search by name or email

Need help? Ask event staff
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Monitoring & Success Metrics

### Key Metrics to Track:

**Usage Metrics:**
- % of check-ins using camera vs manual search
- Average time per check-in
- Number of camera permission denials
- Browser types used

**Issue Metrics:**
- Number of camera-related support tickets
- Common error messages
- Browser compatibility issues

**Success Indicators:**
- ✅ Increased check-in speed
- ✅ Reduced manual search usage
- ✅ Positive staff feedback
- ✅ Fewer USB scanner requests

### Salesforce Reports:

Create reports to track:
1. Check-in timestamps (measure speed)
2. Check-in method used (if tracked)
3. Event attendance patterns
4. Staff user satisfaction

---

## Additional Resources

### Salesforce Documentation:
- [Lightning Web Security Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.rn_lc_lws.htm&release=244&type=5)
- [Enable Lightning Web Security](https://help.salesforce.com/s/articleView?id=sf.lws_enable.htm&type=5)
- [Migrate to LWS Guide](https://help.salesforce.com/s/articleView?id=sf.lws_migrate.htm&type=5)
- [LWS Developer Guide](https://developer.salesforce.com/docs/platform/lwc/guide/security-lwsec.html)

### Component Documentation:
- [LOCKER-SERVICE-CAMERA-ISSUE.md](./LOCKER-SERVICE-CAMERA-ISSUE.md) - Technical explanation
- [QUICK-START.md](./QUICK-START.md) - User quick start guide
- [CAMERA-TROUBLESHOOTING.md](./CAMERA-TROUBLESHOOTING.md) - Troubleshooting guide

### Support:
- Salesforce Help & Training
- Trailblazer Community
- Your Salesforce Account Team

---

## FAQ for Administrators

**Q: Is LWS safe to enable?**  
A: Yes, LWS is Salesforce's recommended modern security framework. It's more secure and performant than Locker Service.

**Q: Will this break my other components?**  
A: Most modern LWCs work fine with LWS. Test in sandbox first. Older Aura components may need updates.

**Q: Can I enable LWS just for Experience Cloud?**  
A: Yes! You can enable it only for Experience Builder sites, leaving Lightning Experience on Locker Service.

**Q: What if users deny camera permission?**  
A: The component gracefully falls back to manual search. No functionality is lost.

**Q: Does this work on all browsers?**  
A: Works on Chrome 53+, Firefox 36+, Edge 79+, Safari 11+. Older browsers fall back to manual search.

**Q: Can I revert if there are issues?**  
A: Yes, simply uncheck the LWS options in Session Settings. Component continues working with fallback methods.

**Q: Does this require code changes?**  
A: No! The component already supports LWS. Just enable it in settings.

**Q: How much does this cost?**  
A: LWS is included in Salesforce at no additional cost.

**Q: Will Salesforce force me to use LWS eventually?**  
A: Salesforce is transitioning all orgs to LWS. Locker Service will eventually be deprecated. Enabling now future-proofs your org.

**Q: What if I have a really old org?**  
A: LWS requires Salesforce version 244+ (Spring '22). Update your org first if needed.

---

## Conclusion

Enabling Lightning Web Security is the **recommended solution** to unlock camera functionality in the Summit Events Check-In component.

**Benefits:**
- ✅ Camera scanning on all devices
- ✅ Better performance
- ✅ Modern security
- ✅ Future-proof
- ✅ No code changes needed

**Next Steps:**
1. Test in sandbox
2. Enable in production
3. Train staff
4. Monitor usage
5. Celebrate faster check-ins! 🎉

For questions or assistance, contact your Salesforce administrator or support team.

