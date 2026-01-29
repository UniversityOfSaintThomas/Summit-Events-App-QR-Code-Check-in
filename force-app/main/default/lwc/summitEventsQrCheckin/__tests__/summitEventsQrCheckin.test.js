import { createElement } from 'lwc';
import SummitEventsQrCheckin from 'c/summitEventsQrCheckin';
import lookupRegistrant from '@salesforce/apex/summitEventsCheckin.lookupRegistrant';
import checkInRegistrant from '@salesforce/apex/summitEventsCheckin.checkInRegistrant';
import getEventInstancesByDate from '@salesforce/apex/summitEventsCheckin.getEventInstancesByDate';

// Mock the Apex methods
jest.mock('@salesforce/apex/summitEventsCheckin.lookupRegistrant', () => ({
    default: jest.fn()
}), { virtual: true });

jest.mock('@salesforce/apex/summitEventsCheckin.checkInRegistrant', () => ({
    default: jest.fn()
}), { virtual: true });

jest.mock('@salesforce/apex/summitEventsCheckin.getEventInstancesByDate', () => ({
    default: jest.fn()
}), { virtual: true });

// Helper to flush promises
const flushPromises = () => new Promise(resolve => setTimeout(resolve, 0));

describe('c-summit-events-qr-checkin', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('renders component with initial state', () => {
        const element = createElement('c-summit-events-qr-checkin', {
            is: SummitEventsQrCheckin
        });
        document.body.appendChild(element);

        const card = element.shadowRoot.querySelector('lightning-card');
        expect(card).toBeTruthy();
    });

    it('shows component structure on load', async () => {
        const element = createElement('c-summit-events-qr-checkin', {
            is: SummitEventsQrCheckin
        });
        document.body.appendChild(element);

        await flushPromises();

        // Component should render
        const card = element.shadowRoot.querySelector('lightning-card');
        expect(card).toBeTruthy();
    });

    it('has configurable check-in status', () => {
        const element = createElement('c-summit-events-qr-checkin', {
            is: SummitEventsQrCheckin
        });
        element.checkinStatus = 'Attended';
        document.body.appendChild(element);

        expect(element.checkinStatus).toBe('Attended');
    });

    it('has configurable title', () => {
        const element = createElement('c-summit-events-qr-checkin', {
            is: SummitEventsQrCheckin
        });
        element.title = 'Custom Check-In Title';
        document.body.appendChild(element);

        expect(element.title).toBe('Custom Check-In Title');
    });

    it('accepts recordId from parent (context-aware)', () => {
        const element = createElement('c-summit-events-qr-checkin', {
            is: SummitEventsQrCheckin
        });
        element.recordId = 'a06XXXXXXXXXXXX';
        document.body.appendChild(element);

        expect(element.recordId).toBe('a06XXXXXXXXXXXX');
    });

    it('accepts objectApiName from parent (context-aware)', () => {
        const element = createElement('c-summit-events-qr-checkin', {
            is: SummitEventsQrCheckin
        });
        element.objectApiName = 'summit__Summit_Events_Instance__c';
        document.body.appendChild(element);

        expect(element.objectApiName).toBe('summit__Summit_Events_Instance__c');
    });

    it('renders without errors when no props provided', () => {
        const element = createElement('c-summit-events-qr-checkin', {
            is: SummitEventsQrCheckin
        });

        // Should not throw when appending to DOM
        expect(() => {
            document.body.appendChild(element);
        }).not.toThrow();
    });
});

