# Salesforce Locker Service Camera Blocking Issue
- 🔄 Salesforce is transitioning all orgs from Locker Service to LWS
## The Problem
- 📅 LWS has been available since Spring '22 (v244)
When your LWC component is running in **Experience Cloud** or **Lightning**, Salesforce's security layer (**Locker Service** or **Lightning Web Security**) **blocks access to `navigator.mediaDevices`**, even when:

**Advantages:**
Salesforce restricts access to certain browser APIs for security reasons. The `navigator.mediaDevices` API is one of them, because it can:
- Access user's camera and microphone

```javascript
Salesforce restricts access to certain browser APIs for security reasons. The `navigator.mediaDevices` API is one of them, because it can:
- Access user's camera and microphone
- Potentially leak sensitive information
- Create privacy concerns
    // Show helpful error message ℹ️
    // Recommend alternatives
}
```

## Recommended Implementation

### For Mobile Users:
The component shows accurate error messages:

### When Camera Blocked (Locker Service):
1. **Primary:** Manual search with keyboard
2. **Alternative:** USB barcode scanner
3. **Not Available:** Browser camera (blocked by Locker Service)

Please enable Lightning Web Security in Setup → Session Settings,
or use the Salesforce Mobile App for camera scanning,
or use manual search.
- Train staff on manual search as backup
- Consider USB scanners for desktop check-in stations
### Console Logs (Locker Service):
## Future Considerations

   (likely blocked by Locker Service)
ℹ️ Recommendation: Enable Lightning Web Security or 
   use Salesforce Mobile App or manual search
```

### When Camera Works (LWS Enabled):
3. **Custom Experience Builder component** - Might have different API access levels
✅ All checks passed - starting camera scanner
```
Camera opens successfully!

### Monitor These:
- Salesforce Release Notes for "Lightning Web Security" or "Locker Service" updates
- IdeaExchange post about camera API access
- Experience Cloud API updates

## Testing Matrix

| Environment | Browser Camera | Mobile Scanner | Manual Search |
|-------------|---------------|----------------|---------------|
| Experience Cloud (Desktop) | ❌ Blocked | N/A | ✅ Works |
| Experience Cloud (Mobile Web) | ❌ Blocked | N/A | ✅ Works |
| Salesforce Mobile App | N/A | ✅ Works | ✅ Works |
| Lightning App Builder | ❌ Blocked | N/A | ✅ Works |
| Visualforce Page | ⚠️ May work* | N/A | ✅ Works |

\* Visualforce pages may have less strict security, but mixing Visualforce with LWC is not recommended.

## Error Message Strategy

The component now shows accurate error messages:

### When Camera Blocked:
```
Camera Not Available

Camera access is blocked by browser security. 
Please use the Salesforce Mobile App for camera 
scanning, or use manual search.
```

### Console Logs:
```
❌ navigator.mediaDevices is not available 
   (likely blocked by Locker Service/LWS)
ℹ️ Recommendation: Use Salesforce Mobile App 
   or manual search
```

### For Event Page (LWS Enabled):

### For Event Page:
> **Check-In Options:**
> - 📷 **Desktop:** Click "Scan with Camera" to use your webcam
> - 📱 **Mobile:** Use browser or Salesforce Mobile App for QR scanning
> - 🔍 **All Devices:** Use manual search by name or email

### For Event Page (LWS Not Enabled):
Add instructions near the component:

> **Check-In Options:**
> - 📱 **Mobile:** Use Salesforce Mobile App for QR scanning
> - 💻 **Desktop:** Use manual search by name or email
### For Staff Training (LWS Enabled):
1. Primary: Camera scanning on any device
2. Backup: Manual name search
3. Mobile bonus: Salesforce Mobile App native scanner

### For Staff Training (LWS Not Enabled):

### For Staff Training:
1. Primary: Salesforce Mobile App on tablets
2. Backup: Manual name search
3. Alternative: USB scanners at check-in desk

## Summary

**The camera blocking is a Salesforce security feature, not a bug.**

Your component is correctly implemented with:
- ✅ Automatic mobile scanner detection
- ✅ Browser camera attempt (with graceful failure)
- ✅ Clear error messages
- ✅ Manual search fallback
- ✅ Good user experience on all platforms

**Recommended deployment:**
- Staff tablets: Salesforce Mobile App
- Check-in desk: Manual search + USB scanner
- Attendee self-check-in: Manual search by name

## Additional Resources

- [Salesforce Lightning Locker Documentation](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/security_locker)
- [Lightning Web Security (LWS)](https://developer.salesforce.com/docs/platform/lwc/guide/security-lwsec.html)
- [Mobile Barcode Scanner API](https://developer.salesforce.com/docs/component-library/bundle/lightning-mobileCapabilities/documentation)

