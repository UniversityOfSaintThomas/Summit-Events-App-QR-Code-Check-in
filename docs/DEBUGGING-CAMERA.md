# Desktop Camera Debugging Guide

## Overview
The QR scanner now includes comprehensive debugging logs to help identify performance bottlenecks and scanning issues on desktop cameras.

## How to View Debug Logs

1. **Open Browser Developer Console**
   - Press `F12` or `Ctrl+Shift+I` (Windows/Linux)
   - Press `Cmd+Option+I` (Mac)
   - Or right-click → Inspect → Console tab

2. **Start Camera Scanner**
   - Click "Scan with Camera" button
   - Watch console for debug output

3. **Position QR Code**
   - Hold QR code in front of camera
   - Observe scan attempts in console every second

## Understanding the Debug Output

### Camera Startup Logs

```
🎬 Camera startup initiated
📷 Requesting camera access with 720p...
✅ Camera access granted in XXX.XXms
▶️ Starting video playback...
✅ Video playing in XXX.XXms
⏳ Waiting for video to be ready...
✅ Video ready in XXX.XXms (readyState: X)
🎉 Total camera startup time: XXX.XXms
📹 Camera initialized: { videoWidth, videoHeight, canvasWidth, canvasHeight, readyState }
✅ Scanning started - will scan once per second
```

**What to Look For:**
- **Total startup time** should be 1000-2000ms
  - If > 3000ms: Slow camera initialization (hardware/driver issue)
  - If > 5000ms: Browser or OS performance problem
  
- **Camera access time** should be < 500ms
  - If > 1000ms: Camera hardware slow to initialize
  
- **Video ready time** should be < 1000ms
  - If > 2000ms: Video stream not loading properly

### Scanning Loop Logs

Every second you'll see:

```
🔍 Scan #X started at XXXX.XXms
  📐 Canvas draw time: X.XXms
  🖼️ GetImageData time: X.XXms (XXXXXX bytes)
  🔎 QR detection time: XX.XXms
  ⏱️ Total scan time: XX.XXms
  ❌ No QR code found in this frame
```

**OR if QR code detected:**

```
🔍 Scan #X started at XXXX.XXms
  📐 Canvas draw time: X.XXms
  🖼️ GetImageData time: X.XXms (XXXXXX bytes)
  🔎 QR detection time: XX.XXms
  ⏱️ Total scan time: XX.XXms
✅ QR CODE FOUND! Data: "..." (scan #X, XX.XXms)
```

### Performance Metrics Breakdown

#### Canvas Draw Time
**Normal:** 1-5ms  
**Slow:** > 10ms  
**Problem:** GPU/browser rendering issue

```
📐 Canvas draw time: X.XXms
```

**If slow (> 10ms):**
- Close other browser tabs
- Disable browser extensions
- Update graphics drivers
- Try different browser (Chrome recommended)

#### GetImageData Time
**Normal:** 3-15ms  
**Slow:** > 30ms  
**Problem:** Canvas pixel access bottleneck

```
🖼️ GetImageData time: X.XXms (XXXXXX bytes)
```

**If slow (> 30ms):**
- Canvas size might be too large
- Browser struggling with memory
- Try closing other apps to free RAM

**Byte count should be:**
- For 1280×720: ~3,686,400 bytes (1280 × 720 × 4)
- For 640×480: ~1,228,800 bytes (640 × 480 × 4)

#### QR Detection Time
**Normal:** 10-30ms  
**Slow:** > 50ms  
**Problem:** CPU struggling with QR algorithm

```
🔎 QR detection time: XX.XXms
```

**If slow (> 50ms):**
- CPU is overloaded
- Close other applications
- Try on a faster computer
- QR code might be partially visible (algorithm works harder)

#### Total Scan Time
**Normal:** 15-50ms  
**Slow:** > 100ms  
**Problem:** Overall performance issue

```
⏱️ Total scan time: XX.XXms
```

**Should always be < 1000ms** since scans happen every 1 second.

### Skipped Scans

```
⏭️ Skipping scan - video not ready: { hasStream, readyState }
```

**Why this happens:**
- Video stream disconnected
- Camera temporarily unavailable
- Browser paused video (tab in background)

**If this happens frequently:**
- Camera hardware issue
- USB camera connection unstable
- Browser tab backgrounded (normal behavior)

## Typical Performance Numbers

### Good Performance (Reliable Scanning)
```
🎉 Total camera startup time: 1200.00ms
📐 Canvas draw time: 2.50ms
🖼️ GetImageData time: 8.20ms (3686400 bytes)
🔎 QR detection time: 15.30ms
⏱️ Total scan time: 26.00ms
```

### Acceptable Performance (Usually Works)
```
🎉 Total camera startup time: 2500.00ms
📐 Canvas draw time: 5.00ms
🖼️ GetImageData time: 20.00ms (3686400 bytes)
🔎 QR detection time: 35.00ms
⏱️ Total scan time: 60.00ms
```

### Poor Performance (Unreliable)
```
🎉 Total camera startup time: 5000.00ms
📐 Canvas draw time: 15.00ms
🖼️ GetImageData time: 50.00ms (3686400 bytes)
🔎 QR detection time: 80.00ms
⏱️ Total scan time: 145.00ms
```

## Common Issues and Solutions

### Issue: QR Code Never Detected

**Check the logs for:**

1. **Is scanning happening?**
   - Should see `🔍 Scan #X` every second
   - If not: Scanner stopped or crashed

2. **Is QR detection running?**
   - Should see `🔎 QR detection time` in each scan
   - If not: jsQR library not loaded

3. **Are there errors?**
   - Look for `❌ QR scan error:` messages
   - Check full error details

**Common causes:**
- QR code too blurry (camera focus issue)
- QR code too small (move closer)
- QR code too large (move back)
- Poor lighting (add more light)
- QR code at angle (hold flat)

### Issue: Scanning Very Slow (> 10 seconds)

**Check timing in logs:**

```
Scan #1: Total 25ms → ❌ No QR
Scan #2: Total 28ms → ❌ No QR
Scan #3: Total 22ms → ❌ No QR
...
Scan #15: Total 26ms → ✅ FOUND!
```

This is **normal** - each scan is fast (< 30ms), but QR code not visible/clear in first 14 scans.

**Causes:**
- Camera auto-focus taking time to lock on
- QR code moving/shaking
- Poor positioning
- Glare on QR code

**Solutions:**
- Hold QR code steady for 3-5 seconds
- Ensure good lighting
- Keep QR code 6-12 inches from camera
- Wait for camera to focus (first second after opening)

### Issue: Scans Taking > 100ms Each

**Example poor performance:**
```
🔍 Scan #1 started
  📐 Canvas draw time: 25.00ms  ← SLOW!
  🖼️ GetImageData time: 75.00ms  ← VERY SLOW!
  🔎 QR detection time: 90.00ms  ← VERY SLOW!
  ⏱️ Total scan time: 190.00ms
```

**This indicates:**
- Computer/browser struggling
- Too many other apps running
- Outdated browser
- Hardware limitations

**Solutions:**
- Close other browser tabs
- Close other applications
- Update browser to latest version
- Try Chrome (best performance)
- Use a faster computer if available

### Issue: Camera Startup > 5 seconds

**Check startup breakdown:**
```
📷 Requesting camera access with 720p...
✅ Camera access granted in 3500.00ms  ← SLOW!
⏳ Waiting for video to be ready...
✅ Video ready in 2200.00ms  ← SLOW!
🎉 Total camera startup time: 5800.00ms
```

**Common causes:**
- Slow camera hardware (webcam)
- USB bandwidth issues
- Driver problems
- Other apps using camera

**Solutions:**
- Disconnect other USB devices
- Try different USB port
- Update camera drivers
- Close apps that might use camera (Zoom, Teams, etc.)
- Reboot computer

## How to Share Debug Logs

If you need to report a scanning issue:

1. **Open console** (F12)
2. **Click "Scan with Camera"**
3. **Wait through several scan attempts**
4. **Right-click in console** → "Save as..."
5. **Save console log** to file
6. **Share file** or copy/paste relevant section

**What to include:**
- Camera startup logs (first ~10 lines)
- At least 5 scan attempts
- The specific scan where issue occurred
- Any error messages (red text)

## Performance Tuning

### If QR Detection is Slow (> 50ms consistently)

The QR detection algorithm processes ~3.6 million pixels (for 720p). On slower computers, this can take time.

**Current setting:** 1 scan per second (1000ms interval)

**If needed, can increase interval in code:**
```javascript
}, 1500); // Scan every 1.5 seconds instead of 1 second
```

**Trade-off:**
- Longer interval = More time for algorithm = Better reliability
- Longer interval = Slower detection = User waits longer

### If GetImageData is Slow (> 30ms consistently)

This means browser is struggling to read canvas pixels.

**Check:**
- Canvas size in initialization logs
- Should be 1280×720 or lower
- If higher: Browser requested wrong resolution

**Potential fix:** Request lower resolution
```javascript
// Change ideal from 1280 to 640
width: { ideal: 640 },
height: { ideal: 480 }
```

## Removing Debug Logs (Future)

Once issues are resolved, debug logs can be removed or commented out for production.

**To disable:** Comment out all `console.log` statements in scanning code, or add a debug flag:

```javascript
const DEBUG = false; // Set to false to disable logs

if (DEBUG) {
    console.log('...');
}
```

## Summary

The debug logs provide visibility into:
- ✅ Camera initialization timing
- ✅ Per-scan performance breakdown
- ✅ QR detection success/failure
- ✅ Bottleneck identification

Use this information to:
- 📊 Diagnose slow scanning
- 🔧 Identify performance bottlenecks
- 💡 Understand why QR codes aren't detected
- 🚀 Optimize for specific hardware/browsers
