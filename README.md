# Summit Events QR Check-In System

**Version 0.1** | Production Ready | 89% Test Coverage

A comprehensive event check-in solution for Salesforce Summit Events App with smart camera scanning, manual search, and session management.

---

## 🚀 Quick Start

```bash
# Deploy the code
sf project deploy start --source-dir force-app/main/default/classes --wait 10
sf project deploy start --source-dir force-app/main/default/lwc,force-app/main/default/staticresources --wait 10

# Run tests
sf apex run test --class-names summitEventsCheckinTest --code-coverage --result-format human

# Expected: 35 tests pass, 89% coverage ✅
```

---

## ✨ Features

### 🎥 Smart Multi-Device Scanning
- **Auto-detects device type** (Mobile App, Desktop, Browser)
- **Inline camera scanner** (no modal popups)
- **Native mobile support** (Salesforce BarcodeScanner API)
- **Desktop camera** (jsQR library integration)

### 🔍 Manual Registration Search
- Search by **name** (first, last, or both)
- Search by **email address**
- **Paginated results** (5 per page)
- **Visual status indicators** (checkmarks, badges)

### ✅ Two-Step Check-In
- **Lookup first** - Review details before confirming
- **Prevent accidents** - Confirmation required
- **Undo check-ins** - Revert mistakes easily

### 📊 Session Management
- **Dual counters** - Session scans + Total attended
- **Session timer** - Track session duration
- **Start/Stop/Reset** - Full session control

### 📅 Event Instance Selection
- **Date picker** - Filter events by date
- **Dynamic dropdowns** - Shows relevant instances only
- **Validation** - Must select before starting

---

## 📦 What's Included

```
force-app/main/default/
├── classes/
│   ├── summitEventsCheckin.cls              (7 Apex methods)
│   └── summitEventsCheckinTest.cls          (35 tests, 89% coverage)
├── lwc/summitEventsQrCheckin/
│   ├── summitEventsQrCheckin.js             (Controller)
│   ├── summitEventsQrCheckin.html           (UI)
│   ├── summitEventsQrCheckin.css            (Styles)
│   └── __tests__/                           (Jest tests)
└── staticresources/
    └── jsQR.js                              (QR scanner library)
```

---

## 📖 Documentation

- **[V1.0 Release Notes](docs/V0.1-RELEASE-NOTES.md)** - Complete feature list & installation
- **[User Guide](docs/USER-GUIDE.md)** - How to use the component
- **[Architecture](docs/ARCHITECTURE.md)** - Technical documentation
- **[Deployment Guide](DEPLOYMENT_ORDER.md)** - Step-by-step deployment

---

## 🎯 Use Cases

### Event Check-In Desk
1. Select event instance
2. Start scanning session
3. Scan QR codes from badges
4. Monitor counters

### Mobile Check-In
1. Use Salesforce Mobile App
2. Native camera scanner
3. Quick lookup by name
4. One-tap confirmation

### Self-Service Kiosk
1. Add to Experience Cloud site
2. Guest users can check in
3. Search by name/email
4. Touchscreen friendly

---

## 🎓 Training (30 Seconds)

**For Staff:**
1. Pick date → Pick event → Click "Start"
2. **Camera:** "Scan with Camera" → Point → Confirm
3. **Search:** Type name → Select → Confirm
4. **Undo:** Scan again → Click "Undo Check-In"

**Status Colors:**
- 🟢 Green = Success
- 🟡 Yellow = Already checked in
- 🔴 Red = Error

---

## 🔧 Requirements

- Salesforce Summit Events App installed
- Modern browser (Chrome 83+, Firefox 78+, Edge 83+, Safari 14+)
- Camera permission (for camera scanning)
- Object permissions: Summit Events Registration (Read, Edit)

---

## ⚡ Performance

- **Check-in speed:** 3-5 seconds (with confirmation)
- **Camera scan:** 1-2 seconds
- **Search response:** < 1 second
- **Governor limits:** Safe for high volume (1 SOQL + 1 DML per check-in)

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Camera not working | Check browser permissions, use Chrome/Firefox/Edge/Safari |
| "No registration found" | Verify QR code value, check instance selection |
| Permission errors | Enable Apex class, grant object permissions |
| Search returns nothing | Check spelling, try partial names, verify instance |

**Full troubleshooting guide:** See [V1.0 Release Notes](docs/V0.1-RELEASE-NOTES.md#-troubleshooting)

---

## 📊 Test Coverage

```
Classes: 89% coverage (target: 75%)
Tests: 35 passing
Time: < 2 seconds
Status: ✅ Production Ready
```

**Key test scenarios:**
- Check-in workflow (11 tests)
- Search operations (7 tests)
- Undo check-in (5 tests)
- Event instance lookup (3 tests)
- Lookup operations (6 tests)
- Counter functionality (3 tests)

---

## 🗺️ Roadmap

### Version 1.1 (Planned)
- Offline mode with sync
- Bulk check-in from list
- Check-in timestamp tracking
- Export reports
- SMS/Email confirmations

---

## 📞 Support

- **Documentation:** See `docs/` folder
- **Community:** [Summit Events App GitHub](https://github.com/SFDO-Community/Summit-Events-App)
- **Issues:** Check browser console (F12) and Salesforce debug logs

---

## 🏆 Credits

Built for the Salesforce Summit Events App community using Lightning Web Components, jsQR library, and Salesforce Mobile BarcodeScanner API.

---

## 📄 License

BSD-3-Clause (same as Summit Events App)

---

**Ready to deploy? See [DEPLOYMENT_ORDER.md](DEPLOYMENT_ORDER.md) for step-by-step instructions.**

| Browser | Desktop Camera | Mobile App | USB Scanner |
|---------|---------------|------------|-------------|
| Chrome 83+ | ✅ Yes | ✅ Yes | ✅ Yes |
| Firefox | ✅ Yes | ✅ Yes | ✅ Yes |
| Edge 83+ | ✅ Yes | ✅ Yes | ✅ Yes |
| Safari 11+ | ✅ Yes | ✅ Yes | ✅ Yes |

## Documentation

- **[Complete User Guide](docs/README.md)** - Full documentation
- **[Technical Reference](docs/TECHNICAL_REFERENCE.md)** - Developer documentation
- **[Architecture](docs/ARCHITECTURE.md)** - Component architecture
- **[Check-in Details](docs/CHECKIN_README.md)** - Check-in process details

## Project Structure

```
force-app/main/default/
├── classes/                    # Apex classes
│   ├── summitEventsCheckin.cls
│   └── summitEventsCheckinTest.cls
├── lwc/                        # Lightning Web Component
│   └── summitEventsQrCheckin/
│       ├── summitEventsQrCheckin.js
│       ├── summitEventsQrCheckin.html
│       ├── summitEventsQrCheckin.css
│       └── summitEventsQrCheckin.js-meta.xml
└── staticresources/            # Static resources
    └── jsQR.js                 # QR code detection library
```

## Contributing

This component is part of the [Summit Events App](https://github.com/SFDO-Community/Summit-Events-App).

## License

See the Summit Events App repository for license information.

## Support

For issues or questions, please refer to the [complete documentation](docs/README.md) or submit an issue in the Summit Events App repository.

