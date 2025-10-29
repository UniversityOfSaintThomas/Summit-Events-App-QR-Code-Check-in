# Technical Reference Guide

Detailed technical documentation for developers working with the Summit Events QR Check-In component.

---

## Table of Contents

1. [Component API](#component-api)
2. [Apex Classes](#apex-classes)
3. [Static Resources](#static-resources)
4. [Browser APIs Used](#browser-apis-used)
5. [Security Considerations](#security-considerations)
6. [Performance Optimization](#performance-optimization)

---

## Component API

### Public Properties

#### `@api title`
- **Type**: String
- **Default**: `'Event Check-In'`
- **Description**: Configurable card title displayed at the top of the component
- **Usage**: Set in Experience Builder or Lightning App Builder

### Tracked Properties

#### `@track qrCodeInput`
- **Type**: String
- **Description**: Current QR code value being processed

#### `@track scanCount`
- **Type**: Number
- **Description**: Number of successful check-ins in current session

#### `@track sessionActive`
- **Type**: Boolean
- **Description**: Whether a scanning session is currently active

#### `@track showCameraScanner`
- **Type**: Boolean
- **Description**: Controls camera modal visibility

### Component Methods

#### `handleStartSession()`
Initializes a new scanning session
- Sets `sessionActive = true`
- Initializes counter to 0
- Starts session timer
- Auto-focuses input field

#### `handleBrowserCameraScan()`
Smart camera handler with device detection
- Detects Salesforce Mobile App vs Desktop
- Routes to appropriate scanner method
- Handles permission errors

#### `handleScanWithCamera()`
Salesforce Mobile App native scanner
- Uses BarcodeScanner API
- Supports multiple barcode formats
- Returns scanned value

#### `startCameraScanning()`
Desktop camera scanning with jsQR
- Uses getUserMedia API
- Processes video frames with jsQR
- Detects QR codes automatically

#### `handleCheckIn()`
Processes check-in for scanned QR code
- Validates session active
- Validates QR code not empty
- Calls Apex method
- Updates UI with result
- Increments counter

---

## Apex Classes

### summitEventsCheckin

#### Class Definition

```apex
public with sharing class summitEventsCheckin {
    
    @AuraEnabled
    public static CheckinResult checkInRegistrant(String qrCodeValue) {
        // Implementation
    }
    
    public class CheckinResult {
        @AuraEnabled public Boolean success;
        @AuraEnabled public Boolean alreadyCheckedIn;
        @AuraEnabled public String message;
        @AuraEnabled public String registrantName;
        @AuraEnabled public String eventName;
        @AuraEnabled public String instanceTitle;
        @AuraEnabled public String registrationId;
    }
}
```

#### Method: checkInRegistrant

**Parameters**:
- `qrCodeValue` (String): The QR code value to look up

**Returns**: `CheckinResult` wrapper with check-in details

**Process**:
1. Validate qrCodeValue not empty
2. Query `Summit_Events_Registration__c` by QR code
3. Check if already attended
4. Update status to 'Attended'
5. Return result with registrant details

**Security**: 
- Uses `with sharing` for record-level security
- Validates user has access to registration records

#### Wrapper Class: CheckinResult

**Properties**:
- `success` (Boolean): Whether check-in was successful
- `alreadyCheckedIn` (Boolean): If registrant was already checked in
- `message` (String): User-friendly message
- `registrantName` (String): Full name of registrant
- `eventName` (String): Name of the event
- `instanceTitle` (String): Event instance title
- `registrationId` (String): Salesforce record ID

---

## Static Resources

### jsQR.js

**Size**: 127KB (minified)  
**Version**: 1.4.0  
**Source**: jsdelivr.net CDN  
**License**: MIT

**Purpose**: QR code detection from video frames

**API Used**:
```javascript
jsQR(imageData, width, height, options)
```

**Parameters**:
- `imageData`: Uint8ClampedArray from canvas
- `width`: Image width in pixels
- `height`: Image height in pixels
- `options`: Configuration object

**Returns**:
```javascript
{
    data: "QR code content",
    location: { /* corner coordinates */ }
}
```

**Options Used**:
```javascript
{
    inversionAttempts: 'dontInvert'  // Optimize for black on white QR codes
}
```

---

## Browser APIs Used

### getUserMedia API

**Purpose**: Access device camera  
**Browser Support**: Chrome 53+, Firefox 36+, Edge 79+, Safari 11+

**Usage**:
```javascript
await navigator.mediaDevices.getUserMedia({
    video: { facingMode: 'environment' }
});
```

**Permissions**: Requires user grant camera access

### BarcodeDetector API (Experimental)

**Status**: Not used (Lightning Locker restrictions)  
**Alternative**: jsQR library via static resource

### Canvas API

**Purpose**: Capture video frames for jsQR processing

**Usage**:
```javascript
const canvas = this.refs.canvasElement;
const context = canvas.getContext('2d');
context.drawImage(video, 0, 0, width, height);
const imageData = context.getImageData(0, 0, width, height);
```

### Salesforce BarcodeScanner API

**Purpose**: Native mobile scanning  
**Availability**: Salesforce Mobile App only

**Usage**:
```javascript
import { getBarcodeScanner } from 'lightning/mobileCapabilities';

const scanner = getBarcodeScanner();
if (scanner.isAvailable()) {
    const result = await scanner.beginCapture(options);
}
```

---

## Security Considerations

### Content Security Policy (CSP)

**Issue**: External CDN resources blocked by Salesforce CSP

**Solution**: Host jsQR as static resource
- Served from Salesforce domain
- No CSP violations
- Cached by Salesforce

### Lightning Locker Service

**Restrictions**:
- BarcodeDetector API not available
- Some browser APIs restricted

**Workaround**: Use approved APIs and static resources

### Data Privacy

**Camera Access**:
- ✅ Video processed client-side only
- ✅ No video data sent to server
- ✅ Only QR code value transmitted
- ✅ Camera stops when modal closes

**QR Code Data**:
- Only QR code value sent to server
- No personal data in transmission
- Server validates access rights

### Record-Level Security

**Apex Class**: Uses `with sharing`
- Respects user permissions
- Only accessible registrations returned
- Standard Salesforce security model

---

## Performance Optimization

### Camera Scanning Performance

**Frame Rate**: 10 FPS (100ms interval)
- Balance between detection speed and CPU usage
- Adequate for QR code detection

**Video Resolution**: 
- Uses default camera resolution
- Canvas sized to match video dimensions

**Detection Optimization**:
```javascript
{
    inversionAttempts: 'dontInvert'
}
```
- Skips color inversion attempts
- Optimized for standard black-on-white QR codes
- Reduces processing time by ~30%

### Static Resource Loading

**Strategy**: Load on component initialization
```javascript
connectedCallback() {
    this.loadJsQRLibrary();
}
```

**Benefits**:
- Library ready before user needs it
- No delay when button clicked
- Cached by browser

### Resource Cleanup

**Camera Stream**:
```javascript
disconnectedCallback() {
    this.stopCameraScanning();
}
```

**Interval Cleanup**:
```javascript
stopCameraScanning() {
    if (this.scanningInterval) {
        clearInterval(this.scanningInterval);
    }
    if (this.videoStream) {
        this.videoStream.getTracks().forEach(track => track.stop());
    }
}
```

### Memory Management

**Video Element**: Released when modal closes  
**Canvas**: Reused for each scan  
**Image Data**: Garbage collected after each frame

---

## Error Handling

### Camera Errors

**NotAllowedError**: User denied camera permission
```javascript
if (error.name === 'NotAllowedError') {
    message = 'Please grant camera permissions';
}
```

**NotFoundError**: No camera available
```javascript
if (error.name === 'NotFoundError') {
    message = 'No camera found on this device';
}
```

### Network Errors

**Static Resource Load Failure**:
```javascript
catch (error) {
    console.error('Error loading jsQR library:', error);
    this.jsQRLoaded = false;
}
```

**Apex Call Failure**:
```javascript
catch (error) {
    this.showToast('Error', 'An unexpected error occurred', 'error');
}
```

---

## Testing

### Jest Tests

**Test File**: `__tests__/summitEventsQrCheckin.test.js`

**Coverage**:
- Component renders correctly
- Session management works
- Check-in processes correctly
- Error handling works

**Mock Strategy**:
```javascript
import checkInRegistrant from '@salesforce/apex/summitEventsCheckin.checkInRegistrant';
jest.mock(
    '@salesforce/apex/summitEventsCheckin.checkInRegistrant',
    () => ({ default: jest.fn() }),
    { virtual: true }
);
```

### Apex Tests

**Test Class**: `summitEventsCheckinTest.cls`

**Coverage**: 100%

**Test Scenarios**:
- Successful check-in
- Already checked in
- Invalid QR code
- Empty QR code
- Null QR code

---

## Best Practices

### Component Usage

1. **Always start session** before scanning
2. **Grant camera permissions** on first use
3. **Use good lighting** for camera scanning
4. **Print QR codes** at 2x2 inches or larger
5. **Have USB scanner backup** for high-volume events

### Development

1. **Test on multiple browsers** before deploying
2. **Check Apex test coverage** is 100%
3. **Run Jest tests** after changes
4. **Clear browser cache** after deployment
5. **Test camera permissions** in different scenarios

### Deployment

1. **Deploy static resources first**
2. **Then deploy Apex classes**
3. **Then deploy LWC component**
4. **Run all tests**
5. **Verify in target org**

---

## Debugging

### Enable Debug Logging

**Browser Console**:
```javascript
console.log('QR Code detected:', code.data);
console.log('Device detection:', isSalesforceMobile);
console.error('Camera error:', error);
```

**Apex Debug Logs**:
Enable for user checking in registrants

### Common Debug Scenarios

**Camera not opening**:
1. Check `jsQRLoaded` flag
2. Verify `getUserMedia` supported
3. Check console for errors
4. Verify permissions granted

**QR code not detecting**:
1. Check video dimensions
2. Verify jsQR library loaded
3. Check lighting conditions
4. Test with different QR codes

**Check-in not processing**:
1. Check Apex debug logs
2. Verify registration exists
3. Check QR code field value
4. Verify user permissions

---

## Migration Notes

### From Previous Versions

**Breaking Changes**: None

**New Features**:
- Smart device detection
- Static resource for jsQR
- Single camera button

**Deprecated**: Multiple camera buttons (consolidated)

---

## Future Enhancements

### Planned Features

- Offline scanning with sync
- Batch QR code processing
- Custom barcode formats
- Analytics dashboard
- Multi-language support

### Extension Points

- Custom check-in actions
- Integration hooks
- Event webhooks
- Custom validation rules

---

**For implementation questions, consult the main README.md**

