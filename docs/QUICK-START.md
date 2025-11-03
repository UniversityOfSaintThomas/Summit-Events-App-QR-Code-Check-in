# Quick Start: Event Check-In Options

## 📦 Installation

**New to this component?**

Install the latest unlocked package from GitHub Releases:

👉 **[Get the Latest Version](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/releases)**

Follow the installation wizard, then return here for setup instructions.

---

## 🎉 Enable Camera for Desktop Browsers!

**Want to use your computer's webcam for QR scanning?**

1. Go to **Setup → Session Settings**
2. Enable **"Lightning Web Security for Lightning Experience"**
3. Enable **"Use Lightning Web Security for Lightning components in Experience Builder sites"**
4. Click **Save**
5. Camera scanning now works in Chrome, Firefox, and Edge! 🎥

**See:** [Full LWS Guide](./LOCKER-SERVICE-CAMERA-ISSUE.md)

---

## Option 1: Browser Camera (Desktop & Mobile)
**✅ Requires Lightning Web Security enabled**

### To Check In:
1. Click **"Start Scanning Session"**
2. Select the event date and instance
3. Click **"Scan with Camera"**
4. Browser opens your device camera
5. Point at QR code on registrant badge
6. Registrant is checked in instantly

**✅ Best for:** Desktop check-in stations, any device with camera

---

## Option 2: Salesforce Mobile App (Mobile Only)

### Setup:
**✅ Best for:** All devices, when camera isn't available, backup method
2. Log in with your Salesforce credentials
3. Navigate to your Experience Cloud site within the app

## Option 4: USB Barcode Scanner (Desktop Only)
1. Tap **"Start Scanning Session"**
2. Select the event date and instance
3. Tap **"Scan with Camera"**
4. Native camera scanner opens automatically
5. Point at QR code on registrant badge
6. Registrant is checked in instantly

**✅ Best for:** Event staff with tablets, mobile check-in stations

---

## Option 2: Manual Search (Works Everywhere)

### To Check In:
1. Click **"Start Scanning Session"**
2. Select the event date and instance
3. In the search section, enter:
   - First Name, OR
   - Last Name, OR
**Browser camera requires Lightning Web Security to be enabled.**
4. Click **"Search"**
### ✅ To Enable Camera:
1. Go to **Setup → Session Settings**
2. Check **"Enable Lightning Web Security for Lightning Experience"**
3. Check **"Use Lightning Web Security for Lightning components in Experience Builder sites"**
4. Save
5. Camera now works! 🎥

### If You Can't Enable LWS Yet:
6. Click **"Check In"** button

**✅ Best for:** Desktop users, when camera isn't working, backup method

---
See `docs/LOCKER-SERVICE-CAMERA-ISSUE.md` for detailed technical explanation.
## Option 3: USB Barcode Scanner (Desktop Only)

### Setup:
1. Connect USB barcode scanner to computer
2. Scanner should emulate keyboard input (most do by default)

### To Check In:
1. Click **"Start Scanning Session"**
2. Select the event date and instance
3. Focus on any text input field in the search area
4. Scan QR code with USB scanner
5. Code appears in the field
6. Press Enter or click Search

**✅ Best for:** Fixed check-in desks, high-volume scanning

---

## Why Can't I Use My Browser Camera?

**Salesforce blocks browser camera access** in Experience Cloud for security reasons. This is expected behavior, not a bug.

### Your Options:
- 📱 Use Salesforce Mobile App
- 🔍 Use manual name search
- 🖨️ Use USB barcode scanner

### More Info:
See `docs/LOCKER-SERVICE-CAMERA-ISSUE.md` for technical details.

---

## Troubleshooting

### "Session Not Started" Error
**Fix:** Click "Start Scanning Session" and select an event date/instance first.

### "No Results" When Searching
**Check:**
- Spelling of name
- Registration exists for selected event instance
- Registration hasn't been deleted

### Can't Find Event Instance
**Check:**
- Selected correct date
- Event instance exists for that date
- You have access to that event

### For Event Organizers:
1. **Enable Lightning Web Security** for camera access on all devices
2. **Test check-in** before event day
3. **Train staff** on camera scanning and manual search backup
4. **Provide devices:**
   - Desktop stations with webcams (LWS enabled)
   - Tablets with Salesforce Mobile App
   - USB scanners as backup
5. **Create printed guides** with these instructions

### Already Checked In
**Solution:** Click the registration to view details, then click "Undo Check-In" if needed.

---

## Best Practices
6. **Test camera** before attendees arrive

### For Event Organizers:
1. **Test check-in** before event day
2. **Train staff** on manual search backup
3. **Provide tablets** with Salesforce Mobile App for best experience
4. **Have USB scanners** at fixed check-in desks
5. **Create printed guides** with these instructions

### For Self-Service:
1. Place **QR codes on badges** for scanning
2. Provide **search kiosk** with manual lookup
3. Post **instructions** near check-in area
4. Have **staff available** to assist

---

## Features

### Session Management:
- **Scan Counter:** Tracks check-ins during your session
- **Total Attended:** Shows all check-ins for the event instance
- **Duration Timer:** Shows how long session has been active
- **Reset Counter:** Start fresh without ending session
- **End Session:** Stop session and see summary

### Search Features:
- Search by first name, last name, or email
- **Pagination:** Browse through large result sets (5 per page)
- **Status Indicators:** See who's already checked in
- **Quick Check-In:** Click result to check in

### Registration Panel:
- View registrant details before confirming
- See event name and instance
- View event date and time
- **Direct link** to registration record
- **Undo check-in** if needed

---

## Quick Tips

- ✅ **Start session first** before attempting any check-ins
- ✅ **Select correct date** and instance every time
- ✅ **Manual search works everywhere** - use it as primary on desktop
- ✅ **Salesforce Mobile App** provides best experience on tablets
- ✅ **Check scan counter** to verify check-ins are being counted
- ✅ **Use "Undo Check-In"** if you make a mistake

---

## Support

For technical issues, see full documentation:
- `docs/LOCKER-SERVICE-CAMERA-ISSUE.md` - Camera blocking explanation
- `docs/CAMERA-TROUBLESHOOTING.md` - General camera troubleshooting
- `docs/USER-GUIDE.md` - Complete user guide

For questions about your event or registrations, contact your Salesforce administrator.

