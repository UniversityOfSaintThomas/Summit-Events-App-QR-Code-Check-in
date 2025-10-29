# Summit Events QR Check-In Component

Lightning Web Component for checking in event registrants using QR codes.

## Features

- **Smart Camera Scanning** - Auto-detects device and uses appropriate camera (Desktop, Mobile App, or Browser)
- **USB Scanner Support** - Works with standard barcode scanners
- **Manual Registration Lookup** - Search for registrations by first and last name
- **Session Management** - Track check-ins with counters and timers
- **Real-time Feedback** - Visual confirmation of check-in status

## Quick Start

### Desktop Users
1. Click "Start Scanning Session"
2. Click "Scan with Camera"
3. Grant camera permission (first time)
4. Point camera at QR code

### Mobile App Users
1. Open Salesforce Mobile App
2. Click "Start Scanning Session"  
3. Click "Scan with Camera"
4. Native scanner opens automatically

### USB Scanner Users
1. Click "Start Scanning Session"
2. Click in the input field
3. Scan QR code with USB scanner
4. Check-in processes automatically

### Manual Lookup
1. Click "Start Scanning Session"
2. Click "Manual Lookup"
3. Enter first and/or last name
4. Click "Search"
5. Select the registration from results
6. Click "Check In Selected"

## Installation

```bash
# Deploy everything
sfdx force:source:deploy -p force-app/main/default

# Run tests
sfdx force:apex:test:run -n summitEventsCheckinTest -r human
```

## Browser Compatibility

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

