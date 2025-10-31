# Summit Events QR Check-In - User Guide

**Version 0.1** | Complete User Documentation

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Starting a Check-In Session](#starting-a-check-in-session)
3. [Checking In Registrants](#checking-in-registrants)
4. [Managing Sessions](#managing-sessions)
5. [Undoing Check-Ins](#undoing-check-ins)
6. [Understanding Visual Feedback](#understanding-visual-feedback)
7. [Tips & Best Practices](#tips--best-practices)
8. [Frequently Asked Questions](#frequently-asked-questions)

---

## Getting Started

### What You'll See

When you first open the check-in page, you'll see:
- Event Instance Date picker
- Event Instance dropdown (appears after selecting date)
- "Start Scanning Session" button
- Instructions text

### Before You Begin

✅ Ensure you have:
- Access to the check-in page (via app or Experience Cloud)
- Login credentials (if required)
- Event date and instance information
- QR codes on registration badges (or attendee names for manual lookup)

---

## Starting a Check-In Session

### Step 1: Select Event Date

1. Click the **"Event Instance Date"** calendar field
2. Choose the date of your event
3. Wait for instance dropdown to populate

### Step 2: Select Event Instance

1. Click the **"Event Instance"** dropdown
2. Select your specific event from the list
3. Each instance shows: Event Name - Instance Title - Date

### Step 3: Start Session

1. Click **"Start Scanning Session"** button
2. The interface changes to show:
   - Active session indicator (green dot)
   - Session duration timer
   - Check-in counters (Session + Total)
   - "Scan with Camera" button
   - Manual search fields

**You're now ready to check in registrants!**

---

## Checking In Registrants

### Method 1: Camera Scanning (Recommended)

**For Desktop/Browser Users:**
1. Click **"Scan with Camera"** button
2. **First time only:** Grant camera permission when prompted
3. Inline camera view appears below the button
4. Point camera at QR code on badge
5. Hold steady for 1-2 seconds
6. QR code automatically detected
7. Registration details display in card
8. Review name, event, date
9. Click **"Check In"** button to confirm
10. Success! Counter increments
11. Repeat for next registrant

**For Salesforce Mobile App Users:**
1. Click **"Scan with Camera"** button
2. Native camera scanner opens (full screen)
3. Point phone at QR code
4. Scanner automatically detects and closes
5. Registration details display
6. Tap **"Check In"** to confirm
7. Success! Counter increments
8. Repeat for next registrant

**Camera Tips:**
- Keep QR code within camera view
- Ensure good lighting
- Hold device steady
- 2-6 inches distance works best
- Clean camera lens if having trouble

### Method 2: Manual Search

**When to use:**
- No QR code available
- Badge is damaged/unreadable
- Registrant forgot badge
- Camera not working

**How to search:**
1. In the "Search by Name" section:
   - Enter **First Name** (optional)
   - Enter **Last Name** (optional)
   - Enter **Email** (optional)
2. Click **"Search"** button
3. Results appear below (5 per page)

**Understanding Results:**
- Each result shows:
  - Registrant name
  - Event name and instance
  - Email address
  - Status badge (with icon if already checked in)

**Selecting a Registrant:**
1. Click on the result card (entire card is clickable)
2. Registration details display
3. Review information
4. Click **"Check In"** button to confirm

**Pagination:**
- Use **"Previous"** / **"Next"** buttons to navigate pages
- Shows "Page X of Y" and "1-5 of Z" totals

---

## Managing Sessions

### Viewing Session Information

**Session Status Bar:**
- 🟢 Green dot = Session active
- Duration timer shows elapsed time

**Counters:**
- **This Session:** Count of check-ins in current session
- **Total Attended:** All registrants marked as attended for this instance

### Session Menu Options

Click the **"Session"** dropdown button (top right) for options:

#### Reset Counter
- Clears the "This Session" counter back to 0
- Session remains active
- Total Attended counter unchanged
- Use when starting a new shift or break

#### End Session
- Stops the check-in session
- Shows summary: "Checked in X registrants in Y minutes"
- Clears all fields
- Must start new session to continue

### When to Reset vs End

**Reset Counter:**
- Shift change between staff
- After a break
- Want to track per-person stats
- Session continues uninterrupted

**End Session:**
- Event is over
- Closing check-in desk
- Need to switch to different event
- Must restart to continue

---

## Undoing Check-Ins

### When You Need to Undo

- Scanned wrong person's badge
- Duplicate scan (same person twice quickly)
- Test scan that shouldn't count
- Registrant changed their mind

### How to Undo

1. **Re-scan or search** for the same registration
2. Notice the **"Already Checked In"** badge (yellow/warning)
3. You'll see TWO buttons:
   - **"Close"** (left) - Just dismiss, no changes
   - **"Undo Check-In"** (right, red) - Reverts to "Registered"
4. Click **"Undo Check-In"**
5. Confirmation message appears
6. Status changes: Attended → Registered
7. Session counter decrements by 1
8. Total attended counter decrements by 1

**Important Notes:**
- Undo only works if status is "Attended"
- Can undo any check-in, even from previous sessions
- Action is immediate (no additional confirmation)
- Use carefully - undoing is permanent

---

## Understanding Visual Feedback

### Registration Found Card

When a registration is scanned or selected:

**Information Displayed:**
- Registrant name
- Event name
- Event instance
- Event date and time
- Link to full registration record (opens in new tab)

**Status Indicators:**
- Green "Check In" button = Ready to confirm
- Yellow "Already Checked In" badge = Duplicate
- "Undo Check-In" button = Can revert if needed

### Search Results

**Status Badges:**
- ✅ **Green badge with checkmark:** Already checked in
- **Plain badge:** Not yet checked in (shows status like "Registered")

**Visual Cues:**
- Hovering over a result highlights it
- Entire card is clickable
- Selected registrant details replace search results

### Toast Notifications

**Success Messages (Green):**
- "Check-in successful!"
- "Check-in successfully undone"
- "Session Started"

**Info Messages (Blue):**
- "Session Ended" (with summary)
- "Already Checked In"

**Warning Messages (Yellow):**
- "Session Not Started"
- "Please select an event instance"

**Error Messages (Red):**
- "No registration found"
- "Error updating registration"
- "Search Error"

### Counter Display

**This Session (Light Box):**
- Clock icon
- Number of check-ins in current session
- Resets when you click "Reset Counter"

**Total Attended (Green Box):**
- Success icon
- Total attended for entire event instance
- Includes all check-ins (current + previous sessions)

---

## Tips & Best Practices

### For Fastest Check-In

1. **Use camera scanning** when possible (1-2 seconds)
2. **Pre-position** badges at table height
3. **Good lighting** = faster scans
4. **Clean camera lens** regularly
5. **Practice** on test data before event

### For Accuracy

1. **Always review** name before confirming
2. **Watch for yellow badges** (already checked in)
3. **Use undo immediately** if you make a mistake
4. **Keep QR codes visible** on badges
5. **Test equipment** before event starts

### For Multiple Check-In Stations

1. **All stations share** the Total Attended counter
2. **Each station tracks** its own Session counter
3. **Coordinate breaks** to avoid gaps
4. **End sessions** when closing station
5. **Monitor both counters** to catch issues

### For Problem Resolution

1. **Yellow badge?** That's OK - just already checked in
2. **Red error?** Try manual search by name
3. **Can't find registrant?** Verify event instance selection
4. **Camera won't work?** Check browser permissions
5. **Still stuck?** Use manual search as fallback

### Before the Event

- [ ] Test with sample registrations
- [ ] Verify camera permissions
- [ ] Check internet connection
- [ ] Print backup attendee list
- [ ] Train all staff on undo procedure
- [ ] Note support contact info

### During the Event

- [ ] Start session at beginning of shift
- [ ] Monitor counters regularly
- [ ] Reset counter at shift change
- [ ] Watch for duplicate scans
- [ ] Note any recurring issues

### After the Event

- [ ] End your session
- [ ] Record final totals
- [ ] Report any issues
- [ ] Note process improvements

---

## Frequently Asked Questions

### General Questions

**Q: Do I need internet connection?**  
A: Yes, currently requires internet. Offline mode planned for v1.1.

**Q: Can multiple people use this at once?**  
A: Yes! Multiple stations can check in simultaneously.

**Q: What if someone checks in twice?**  
A: System detects duplicates and shows yellow "Already Checked In" badge.

**Q: Can I check someone out after check-in?**  
A: Use "Undo Check-In" to revert to "Registered" status. No separate check-out.

### Camera Questions

**Q: Why isn't my camera working?**  
A: Check browser permissions (click lock/camera icon in address bar).

**Q: Does this work on my phone?**  
A: Yes! Salesforce Mobile App uses native scanner. Browser uses jsQR.

**Q: Which browsers work?**  
A: Chrome 83+, Firefox 78+, Edge 83+, Safari 14+

**Q: Can I use my laptop webcam?**  
A: Yes! Desktop browsers use your built-in or USB webcam.

### Search Questions

**Q: Why doesn't search find my registrant?**  
A: Check event instance selection. Verify spelling. Try partial names.

**Q: Can I search by email only?**  
A: Yes! Leave name fields empty, enter email, click Search.

**Q: How many results will I see?**  
A: 5 per page. Use Previous/Next buttons for more.

**Q: What if two people have the same name?**  
A: Results show event instance to help distinguish. Click correct one.

### Session Questions

**Q: What happens if I close my browser?**  
A: Session counter resets. Total attended counter persists.

**Q: When should I reset vs end session?**  
A: Reset = new shift/break. End = closing for the day.

**Q: Do session times matter?**  
A: For your reference only. Check-in doesn't record exact time (v1.1 will).

**Q: Can I change event instance mid-session?**  
A: End current session first, then start new session with different instance.

### Undo Questions

**Q: Can I undo any check-in?**  
A: Yes, as long as status is "Attended". Even from previous sessions.

**Q: What if I undo by mistake?**  
A: Scan/search again and check them back in.

**Q: Does undo affect counters?**  
A: Yes, decrements both session and total attended counters.

**Q: Is there a log of undos?**  
A: Check Salesforce audit fields on registration record.

---

## Quick Reference Card

**Print this section for your check-in desk:**

### Starting Up
1. ☐ Select event date
2. ☐ Select event instance
3. ☐ Click "Start Scanning Session"

### Camera Check-In
1. ☐ Click "Scan with Camera"
2. ☐ Point at QR code
3. ☐ Review name
4. ☐ Click "Check In"

### Manual Check-In
1. ☐ Enter name or email
2. ☐ Click "Search"
3. ☐ Click result
4. ☐ Click "Check In"

### Undo
1. ☐ Scan/search again
2. ☐ Click "Undo Check-In"

### Status Colors
- 🟢 = Success
- 🟡 = Already checked in
- 🔴 = Error

### Session Menu
- Reset Counter = New shift
- End Session = Done for day

---

**Need more help? See full documentation in the `docs/` folder.**

