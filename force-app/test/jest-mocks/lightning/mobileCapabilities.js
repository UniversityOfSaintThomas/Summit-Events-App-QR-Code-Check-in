// Mock for lightning/mobileCapabilities
export const getBarcodeScanner = jest.fn(() => {
    return {
        isAvailable: jest.fn(() => false),
        beginCapture: jest.fn(),
        resumeCapture: jest.fn(),
        endCapture: jest.fn()
    };
});
