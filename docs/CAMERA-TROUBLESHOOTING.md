# Camera Troubleshooting Guide

## Quick Tips for Better QR Scanning

### What You Should See
When the scanner is working correctly:
1. ✅ **Camera feed** displays your environment
2. ✅ **Clean video view** with no overlays
3. ✅ **Instant detection** - QR codes scan within 1-2 seconds of positioning

### Positioning the QR Code
1. **Center the QR code** - Position in the middle of the camera view
2. **Distance** - Hold the QR code 6-12 inches (15-30cm) from the camera
3. **Lighting** - Ensure good lighting on the QR code (avoid glare and shadows)
4. **Steady hold** - Keep the camera and QR code steady for 1-2 seconds
5. **Focus** - Wait for the camera to auto-focus (usually automatic within 0.5s)
6. **Fill the view** - QR code should occupy 40-70% of the camera frame

### Common Scanning Issues

#### "I see the camera but nothing happens when I show the QR code"
- **Too close** - QR code is blurry (move camera back 2-4 inches)
- **Too far** - QR code is too small to read (move camera closer 2-4 inches)
- **Angle** - Hold QR code flat and perpendicular to camera (not tilted)
- **Motion blur** - Keep both camera and QR code completely still
- **Screen reflection** - If scanning from a screen, tilt to avoid glare
- **Wrong QR code** - Ensure it's a Summit Events registration QR code

#### "The scanner sometimes works, sometimes doesn't"
This is usually a **lighting** or **focus** issue:
- ✅ **Move to better lighting** - Overhead or natural light works best
- ✅ **Avoid backlighting** - Don't position QR code against bright window/light
- ✅ **Clean camera lens** - Smudges reduce clarity
- ✅ **Wait for focus** - Give camera 1-2 seconds to stabilize after opening
- ✅ **Check browser** - Chrome/Edge work best; Safari/Firefox may be slower

#### "Camera seems slow or laggy"
This suggests **browser performance** issues:
- Close other browser tabs (reduces CPU load)
- Disable browser extensions temporarily
- Try a different browser (Chrome recommended)
- Check if device is in power-saving mode

### Technical Improvements (v2.3 - Jan 2026)
The scanner now includes:
- ✅ **Optimized scan rate** - Scans at ~10fps (100ms interval) for efficiency
  - 6x less CPU usage than 60fps
  - More reliable detection (algorithm not overwhelmed)
  - Still fast enough for instant QR detection
- ✅ **Higher resolution** - Requests 720p camera feed when available
- ✅ **Video ready check** - Waits for camera to fully initialize before scanning
  - Eliminates slow startup and failed initial scans
- ✅ **Dynamic canvas sizing** - Adapts to video resolution changes in real-time
- ✅ **Optimized context** - Uses `willReadFrequently` hint for better performance
- ✅ **Standard QR codes** - Optimized for normal black-on-white QR codes (fastest detection)
- ✅ **Clean interface** - Minimal UI for distraction-free scanning
- ✅ **Controlled processing** - Rate-limited scanning prevents browser overload

### Performance Metrics
**Expected scan time:** 1-2 seconds from positioning to detection
- 🟢 **Instant (0.1-0.5s)**: Optimal lighting, proper distance, steady hold
- 🟡 **Normal (0.5-2s)**: Good lighting, slight movement, auto-focus delay
- 🔴 **Slow (2-5s)**: Poor lighting, too close/far, motion blur, older device
- ❌ **No scan (5s+)**: Check troubleshooting steps above

---

## "Camera Not Supported" Error

If you see the toast message **"Camera Not Supported: Your browser does not support camera access"**, this guide will help you resolve it.

## Common Causes

### 1. **Non-HTTPS Connection (Most Common)**
Camera access requires a secure context (HTTPS or localhost).

**Solution:**
- Ensure your Experience Cloud site is accessed via `https://` 
- Check Salesforce Experience Cloud settings to enforce HTTPS
- For testing locally, use `localhost` or set up HTTPS

**How to Check:**
1. Open browser console (F12)
2. Look for log message: `❌ Camera requires secure context (HTTPS). Current protocol: http:`
3. Check the URL bar - it should show a lock icon 🔒

### 2. **Browser Compatibility**
The camera API requires modern browser features.

**Supported Browsers:**
- ✅ Chrome 53+
- ✅ Firefox 36+
- ✅ Edge 79+
- ✅ Safari 11+
- ❌ Internet Explorer (not supported)

**How to Check:**
1. Open browser console (F12)
2. Look for these diagnostic logs:
   ```
   🎥 Camera scan initiated
   Secure context: true/false
   navigator.mediaDevices available: true/false
   getUserMedia available: true/false
   ```

### 3. **Browser Permissions Blocked**
The user or browser may have blocked camera access.

**Solution:**
1. Click the camera icon in the browser address bar
2. Select "Allow" for camera access
3. Reload the page
4. Try scanning again

### 4. **Experience Cloud iframe Restrictions**
Some Experience Cloud configurations run components in iframes with restricted permissions.

**Solution:**
1. Check Experience Cloud site settings
2. Ensure camera permissions are not blocked
3. Test outside of Experience Cloud to verify functionality

### 5. **jsQR Library Not Loaded**
The QR scanning library may still be loading.

**Symptoms:**
- Toast: "Scanner Loading: QR code scanner is still loading"
- Console: `⚠️ jsQR library not loaded yet`

**Solution:**
- Wait a few seconds and try again
- Refresh the page if the library fails to load
- Check browser console for `✅ jsQR library loaded successfully` message

## Diagnostic Steps

### Step 1: Check Browser Console
1. Press F12 to open Developer Tools
2. Go to Console tab
3. Click "Scan with Camera" button
4. Look for diagnostic messages:

```javascript
🎥 Camera scan initiated
Session active: true
Secure context: true ✅  (or false ❌)
navigator.mediaDevices available: true ✅  (or false ❌)
getUserMedia available: true ✅  (or false ❌)
jsQR loaded: true ✅  (or false ❌)
jsQR library: true ✅  (or false ❌)
```

### Step 2: Verify HTTPS
1. Check URL bar for `https://`
2. Check for lock icon 🔒
3. If using custom domain, verify SSL certificate is valid

### Step 3: Test Browser API
Paste this in browser console to test camera API:
```javascript
console.log('Secure context:', window.isSecureContext);
console.log('MediaDevices:', !!navigator.mediaDevices);
console.log('getUserMedia:', !!(navigator.mediaDevices?.getUserMedia));
```

All three should return `true`.

### Step 4: Test Camera Access
Paste this in browser console to test camera directly:
```javascript
navigator.mediaDevices.getUserMedia({ video: true })
  .then(stream => {
    console.log('✅ Camera access granted');
    stream.getTracks().forEach(track => track.stop());
  })
  .catch(err => {
    console.error('❌ Camera access denied:', err.name, err.message);
  });
```

## Error Messages Explained

| Error Message | Cause | Solution |
|---------------|-------|----------|
| "Secure Connection Required" | Not using HTTPS | Access site via HTTPS |
| "Camera API Not Available" | Browser too old or API blocked | Update browser or check restrictions |
| "getUserMedia Not Supported" | Browser doesn't support API | Use Chrome/Firefox/Edge |
| "Scanner Loading" | jsQR library still loading | Wait and try again |
| "Camera Error: NotAllowedError" | User denied camera permission | Grant permission in browser |
| "Camera Error: NotFoundError" | No camera on device | Use manual search instead |

## Alternative Solutions

If camera scanning doesn't work:

### 1. **Manual Search**
Use the built-in manual search feature:
- Enter First Name, Last Name, or Email
- Click Search
- Select the registration from results
- Click Check In

### 2. **USB Barcode Scanner** (Desktop Only)
Use a USB barcode scanner that emulates keyboard input:
- Focus on any text input field
- Scan the QR code with USB scanner
- System will auto-detect and process

### 3. **Salesforce Mobile App** (Mobile Only)
When accessed through Salesforce Mobile App:
- Component automatically uses native barcode scanner
- Better performance and reliability
- No browser restrictions

## Still Having Issues?

If none of these solutions work:

1. **Export diagnostic information:**
   - Copy all console logs
   - Note browser name and version
   - Note operating system
   - Take screenshot of error

2. **Contact administrator:**
   - Provide diagnostic information
   - Request Experience Cloud site review
   - Check for organizational security policies

3. **Use manual search** as a workaround while investigating

## Testing Camera in Different Environments

### Local Development (HTTPS Not Required)
✅ Works on `localhost` without HTTPS

### Salesforce Sandbox/Production
✅ All Salesforce orgs use HTTPS by default

### Experience Cloud Sites
⚠️ Check site settings:
1. Go to Setup → Experience Workspaces
2. Select your site
3. Administration → Preferences
4. Verify HTTPS is enforced

### Custom Domains
⚠️ Ensure:
- SSL certificate is valid
- HTTPS redirect is enabled
- No mixed content warnings

## Technical Notes

### Camera API Requirements
- **Secure Context:** HTTPS or localhost
- **User Permission:** User must grant camera access
- **Browser Support:** Modern browsers only
- **No iframe restrictions:** Must allow camera in iframe (if applicable)

### Detection Logic
The component automatically detects:
1. **Salesforce Mobile App:** Uses native barcode scanner
2. **Desktop/Browser:** Uses jsQR camera scanner
3. Falls back to manual search if camera unavailable

### Performance
- Camera scanning runs at 10 FPS
- QR code detection is instant once in frame
- Camera stream stops automatically after scan

