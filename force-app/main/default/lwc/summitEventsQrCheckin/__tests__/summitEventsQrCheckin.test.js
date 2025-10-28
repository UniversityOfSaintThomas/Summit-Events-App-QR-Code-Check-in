import { createElement } from 'lwc';
import SummitEventsQrCheckin from 'c/summitEventsQrCheckin';
import checkInRegistrant from '@salesforce/apex/summitEventsCheckin.checkInRegistrant';

// Mock the Apex method
jest.mock(
    '@salesforce/apex/summitEventsCheckin.checkInRegistrant',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

describe('c-summit-events-qr-checkin', () => {
    afterEach(() => {
        // Clear DOM after each test
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        // Clear mock calls
        jest.clearAllMocks();
    });

    it('renders component with initial state', () => {
        const element = createElement('c-summit-events-qr-checkin', {
            is: SummitEventsQrCheckin
        });
        document.body.appendChild(element);

        const card = element.shadowRoot.querySelector('lightning-card');
        expect(card).toBeTruthy();

        // Check for start session button (visible before session starts)
        const startButton = element.shadowRoot.querySelector('lightning-button[label="Start Scanning Session"]');
        expect(startButton).toBeTruthy();
    });

    it('handles successful check-in', async () => {
        const mockResult = {
            success: true,
            alreadyCheckedIn: false,
            message: 'Check-in successful!',
            registrantName: 'John Doe',
            eventName: 'Test Event',
            instanceTitle: 'Test Instance',
            registrationId: '001XXXXXXXXXXXXXXX'
        };

        checkInRegistrant.mockResolvedValue(mockResult);

        const element = createElement('c-summit-events-qr-checkin', {
            is: SummitEventsQrCheckin
        });
        document.body.appendChild(element);

        // Start session first
        const startButton = element.shadowRoot.querySelector('lightning-button[label="Start Scanning Session"]');
        startButton.click();

        await Promise.resolve();

        const input = element.shadowRoot.querySelector('lightning-input');
        input.value = 'TEST-QR-12345';
        input.dispatchEvent(new CustomEvent('change', { detail: { value: 'TEST-QR-12345' } }));

        const checkinButton = element.shadowRoot.querySelector('lightning-button[label="Check In"]');
        checkinButton.click();

        await Promise.resolve();

        expect(checkInRegistrant).toHaveBeenCalledWith({ qrCodeValue: 'TEST-QR-12345' });
    });

    it('handles already checked in registrant', async () => {
        const mockResult = {
            success: true,
            alreadyCheckedIn: true,
            message: 'This registrant is already checked in',
            registrantName: 'Jane Smith',
            eventName: 'Test Event',
            instanceTitle: 'Test Instance',
            registrationId: '001XXXXXXXXXXXXXXX'
        };

        checkInRegistrant.mockResolvedValue(mockResult);

        const element = createElement('c-summit-events-qr-checkin', {
            is: SummitEventsQrCheckin
        });
        document.body.appendChild(element);

        // Start session first
        const startButton = element.shadowRoot.querySelector('lightning-button[label="Start Scanning Session"]');
        startButton.click();

        await Promise.resolve();

        const input = element.shadowRoot.querySelector('lightning-input');
        input.value = 'TEST-QR-67890';
        input.dispatchEvent(new CustomEvent('change', { detail: { value: 'TEST-QR-67890' } }));

        const checkinButton = element.shadowRoot.querySelector('lightning-button[label="Check In"]');
        checkinButton.click();

        await Promise.resolve();

        expect(checkInRegistrant).toHaveBeenCalledWith({ qrCodeValue: 'TEST-QR-67890' });
    });

    it('handles check-in error', async () => {
        const mockResult = {
            success: false,
            alreadyCheckedIn: false,
            message: 'No registration found with this QR code',
            registrantName: '',
            eventName: '',
            instanceTitle: '',
            registrationId: ''
        };

        checkInRegistrant.mockResolvedValue(mockResult);

        const element = createElement('c-summit-events-qr-checkin', {
            is: SummitEventsQrCheckin
        });
        document.body.appendChild(element);

        // Start session first
        const startButton = element.shadowRoot.querySelector('lightning-button[label="Start Scanning Session"]');
        startButton.click();

        await Promise.resolve();

        const input = element.shadowRoot.querySelector('lightning-input');
        input.value = 'INVALID-QR';
        input.dispatchEvent(new CustomEvent('change', { detail: { value: 'INVALID-QR' } }));

        const checkinButton = element.shadowRoot.querySelector('lightning-button[label="Check In"]');
        checkinButton.click();

        await Promise.resolve();

        expect(checkInRegistrant).toHaveBeenCalledWith({ qrCodeValue: 'INVALID-QR' });
    });

    it('clears input on clear button click', async () => {
        const element = createElement('c-summit-events-qr-checkin', {
            is: SummitEventsQrCheckin
        });
        document.body.appendChild(element);

        // Start session first
        const startButton = element.shadowRoot.querySelector('lightning-button[label="Start Scanning Session"]');
        startButton.click();

        await Promise.resolve();

        const input = element.shadowRoot.querySelector('lightning-input');
        input.value = 'TEST-QR-12345';
        input.dispatchEvent(new CustomEvent('change', { detail: { value: 'TEST-QR-12345' } }));

        const clearButton = element.shadowRoot.querySelector('lightning-button[label="Clear"]');
        clearButton.click();

        return Promise.resolve().then(() => {
            expect(element.qrCodeInput).toBe('');
        });
    });
});

