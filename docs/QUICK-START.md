# Quick Start Guide - Summit Events QR Check-In

**Get started with event check-in in 2 minutes!**

---

## 📦 Installation

Install the latest unlocked package:

👉 **[Download Latest Release](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/releases)**

Follow the installation wizard, then add the component to your Lightning page.

---

## 🚀 Quick Setup

### 1. Add Component to Page

**Option A: On Summit Events Instance Record Page** (Recommended)
- Component auto-loads the instance
- No date/instance selection needed
- Fastest setup for check-in

**Option B: On App/Home/Community Page**
- Shows date picker and instance dropdown
- Works anywhere in Salesforce

### 2. Enable Camera (Optional - Desktop Only)

**For desktop browser camera scanning:**

1. Go to **Setup → Session Settings**
2. Enable **"Use Lightning Web Security (LWS) for Lightning components in Experience Builder sites"**
3. Click **Save**

**Note 1:** In order for LWS to take effect you may have to clear your browser cache.
**Note 2:** Salesforce Mobile App camera works without this - it uses native scanner!

See [LWS Enablement Guide](LWS-ENABLEMENT-GUIDE.md) for details.

---

## ✅ Check-In Methods (Priority Order)

The component automatically uses the best available method:

### 1. Salesforce Mobile App Scanner (Best) ⭐
**Used when:** Component opened in Salesforce Mobile App

**How it works:**
- Native camera scanner (fastest, most reliable)
- Automatic - no setup needed
- Click "Scan with Camera" → Native scanner opens
- Instant QR detection

**Best for:** Mobile check-in stations, event staff with tablets/phones

---

### 2. Desktop Browser Camera
**Used when:** Desktop browser with LWS enabled

**How it works:**
- Browser camera with jsQR scanner
- Click "Scan with Camera" → Browser camera opens
- 2-5 second QR detection (optimized for speed)
- Requires HTTPS connection

**Best for:** Desktop check-in stations, laptops

**Requirements:**
- Lightning Web Security enabled (see above)
- Modern browser (Chrome, Firefox, Edge, Safari)
- HTTPS connection

---

### 3. Manual Search (Always Available)
**Used when:** Cameras unavailable or as fallback

**How it works:**
1. Click "Start Scanning Session"
2. Select event instance (if not auto-loaded)
3. Enter registrant's:
   - First Name, OR
   - Last Name, OR
   - Email
4. Click "Search"
5. Click registrant name from results
6. Confirm check-in

**Best for:** 
- Backup when QR codes lost/damaged
- Desktop without camera
- Troubleshooting

---

### 4. USB Barcode Scanner (Desktop)
**Used when:** USB scanner connected to computer

**How it works:**
- Scanner acts as keyboard input
- Click in search field
- Scan QR code → Code appears in field
- Press Enter → Check-in lookup

**Best for:** Desktop stations with dedicated scanner hardware

---

## 📋 Basic Workflow

### Starting a Session

1. **Open Component** (on instance record page OR select date/instance)
2. **Click "Start Scanning Session"**
3. **Choose method:**
   - Tap "Scan with Camera" for QR scanning
   - Enter name/email for manual search

### Checking In Registrants

**With Scanner:**
1. Position QR code in camera view (6-12 inches away)
2. Wait for detection (1-3 seconds typically)
3. Review registrant details
4. Click "Confirm Check-In"

**With Manual Search:**
1. Enter first name, last name, or email
2. Click "Search"
3. Click registrant from results
4. Review details
5. Click "Confirm Check-In"

### Session Management

- **View Stats:** See scan count and total attended/registered
- **Undo Check-In:** Click "Undo" if you make a mistake
- **Reset Counter:** Click "Reset Session" to clear counter
- **End Session:** Click "Stop Session" when done

---

## 💡 Pro Tips

### For Fastest Check-In:
1. Use Salesforce Mobile App with native scanner (instant)
2. Ensure good lighting for camera scanning
3. Pre-position QR codes for quick scanning
4. Train staff on manual search for backup

### For Best Camera Performance:
- Hold QR code 6-12 inches from camera
- Keep QR code centered and steady
- Ensure good overhead lighting
- Use Chrome browser on desktop for best speed

### For Multiple Check-In Stations:
- Place component on instance record page for each event
- No date/instance selection needed
- Faster workflow for staff
- Each station auto-loads correct instance

---

## 🆘 Need Help?

- **[User Guide](USER-GUIDE.md)** - Complete instructions
- **[Camera Troubleshooting](CAMERA-TROUBLESHOOTING.md)** - Camera not working?
- **[LWS Enablement](LWS-ENABLEMENT-GUIDE.md)** - Enable desktop camera
- **[Architecture](ARCHITECTURE.md)** - Technical details

---

**Ready to check in your first registrant!** 🎉

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

