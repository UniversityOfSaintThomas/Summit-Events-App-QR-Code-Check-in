import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
import { loadScript } from 'lightning/platformResourceLoader';
import jsQR from '@salesforce/resourceUrl/jsQR';
import checkInRegistrant from '@salesforce/apex/summitEventsCheckin.checkInRegistrant';

export default class SummitEventsQrCheckin extends LightningElement {
    @api title = 'Event Check-In';
    @track qrCodeInput = '';
    @track isProcessing = false;
    @track lastCheckinResult = null;
    @track showResult = false;
    @track scanCount = 0;
    @track sessionActive = false;
    @track sessionStartTime = null;
    @track showCameraScanner = false;

    myScanner;
    scanButtonDisabled = false;
    videoStream = null;
    scanningInterval = null;
    jsQRLibrary = null;
    jsQRLoaded = false;

    connectedCallback() {
        this.myScanner = getBarcodeScanner();
        if (this.myScanner == null || !this.myScanner.isAvailable()) {
            this.scanButtonDisabled = true;
            console.info('BarcodeScanner unavailable. Non-mobile device? Using manual input mode.');
        }
        this.loadJsQRLibrary();
    }

    disconnectedCallback() {
        this.stopCameraScanning();
    }

    async loadJsQRLibrary() {
        try {
            console.log('Loading jsQR library from static resource...');
            await loadScript(this, jsQR);
            this.jsQRLibrary = window.jsQR;
            this.jsQRLoaded = true;
            console.log('✅ jsQR library loaded successfully from static resource');
        } catch (error) {
            console.error('❌ Error loading jsQR library:', error);
            this.jsQRLoaded = false;
        }
    }

    handleQrCodeChange(event) {
        this.qrCodeInput = event.target.value;
    }

    handleStartSession() {
        this.sessionActive = true;
        this.sessionStartTime = new Date();
        this.scanCount = 0;
        this.showResult = false;
        this.lastCheckinResult = null;
        this.qrCodeInput = '';

        this.showToast('Session Started', 'Scanning session is now active. Ready to check in registrants.', 'success');

        setTimeout(() => {
            const inputField = this.template.querySelector('lightning-input');
            if (inputField) {
                inputField.focus();
            }
        }, 100);
    }

    handleScanWithCamera() {
        if (!this.sessionActive) {
            this.showToast('Session Not Started', 'Please start a scanning session first.', 'warning');
            return;
        }

        if (this.myScanner != null && this.myScanner.isAvailable()) {
            const scanningOptions = {
                barcodeTypes: [
                    this.myScanner.barcodeTypes.QR,
                    this.myScanner.barcodeTypes.CODE_128,
                    this.myScanner.barcodeTypes.CODE_39,
                    this.myScanner.barcodeTypes.CODE_93,
                    this.myScanner.barcodeTypes.DATA_MATRIX,
                    this.myScanner.barcodeTypes.EAN_8,
                    this.myScanner.barcodeTypes.EAN_13,
                    this.myScanner.barcodeTypes.ITF,
                    this.myScanner.barcodeTypes.PDF_417,
                    this.myScanner.barcodeTypes.UPC_A,
                    this.myScanner.barcodeTypes.UPC_E
                ],
                instructionText: 'Scan the registrant QR code',
                successText: 'Scanning complete.'
            };

            this.myScanner.beginCapture(scanningOptions)
                .then((result) => {
                    console.log('Scanned value: ' + result.value);
                    this.qrCodeInput = result.value;
                    this.handleCheckIn();
                })
                .catch((error) => {
                    console.error('Scanning error:', error);
                    if (error.message !== 'USER_DISMISSED') {
                        this.showToast('Scan Error', 'Failed to scan barcode: ' + error.message, 'error');
                    }
                })
                .finally(() => {
                    console.log('Scanning finished.');
                    this.myScanner.endCapture();
                });
        } else {
            this.showToast(
                'Camera Not Available',
                'Camera scanning is only available on mobile devices. Please use manual entry or a USB scanner.',
                'info'
            );
        }
    }

    async handleBrowserCameraScan() {
        if (!this.sessionActive) {
            this.showToast('Session Not Started', 'Please start a scanning session first.', 'warning');
            return;
        }

        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            this.showToast(
                'Camera Not Supported',
                'Your browser does not support camera access. Please use a modern browser like Chrome, Firefox, or Edge.',
                'error'
            );
            return;
        }

        if (!this.jsQRLoaded || !this.jsQRLibrary) {
            this.showToast(
                'Scanner Loading',
                'QR code scanner is still loading. Please try again in a moment.',
                'info'
            );
            return;
        }

        this.showCameraScanner = true;

        setTimeout(() => {
            this.startCameraScanning();
        }, 100);
    }

    async startCameraScanning() {
        try {
            const video = this.refs.videoElement;
            const canvas = this.refs.canvasElement;

            if (!video || !canvas) {
                console.error('Video or canvas element not found');
                return;
            }

            this.videoStream = await navigator.mediaDevices.getUserMedia({
                video: { facingMode: 'environment' }
            });

            video.srcObject = this.videoStream;
            video.setAttribute('playsinline', true);
            await video.play();

            const canvasContext = canvas.getContext('2d');

            this.scanningInterval = setInterval(() => {
                if (video.readyState === video.HAVE_ENOUGH_DATA) {
                    canvas.height = video.videoHeight;
                    canvas.width = video.videoWidth;
                    canvasContext.drawImage(video, 0, 0, canvas.width, canvas.height);

                    const imageData = canvasContext.getImageData(0, 0, canvas.width, canvas.height);
                    const code = this.jsQRLibrary(imageData.data, imageData.width, imageData.height, {
                        inversionAttempts: 'dontInvert'
                    });

                    if (code) {
                        console.log('QR Code detected:', code.data);
                        this.qrCodeInput = code.data;
                        this.handleCloseCameraScanner();
                        this.handleCheckIn();
                    }
                }
            }, 100);

        } catch (error) {
            console.error('Camera access error:', error);
            this.handleCloseCameraScanner();

            let errorMessage = 'Failed to access camera. ';
            if (error.name === 'NotAllowedError') {
                errorMessage += 'Please grant camera permissions in your browser settings.';
            } else if (error.name === 'NotFoundError') {
                errorMessage += 'No camera found on this device.';
            } else {
                errorMessage += error.message;
            }

            this.showToast('Camera Error', errorMessage, 'error');
        }
    }

    handleCloseCameraScanner() {
        this.stopCameraScanning();
        this.showCameraScanner = false;
    }

    stopCameraScanning() {
        if (this.scanningInterval) {
            clearInterval(this.scanningInterval);
            this.scanningInterval = null;
        }

        if (this.videoStream) {
            this.videoStream.getTracks().forEach(track => track.stop());
            this.videoStream = null;
        }
    }

    handleStopSession() {
        this.sessionActive = false;
        const duration = this.getSessionDuration();

        this.showToast(
            'Session Ended',
            `Checked in ${this.scanCount} registrant${this.scanCount !== 1 ? 's' : ''} in ${duration}`,
            'info'
        );
    }

    handleResetSession() {
        this.scanCount = 0;
        this.showResult = false;
        this.lastCheckinResult = null;
        this.qrCodeInput = '';
        this.sessionStartTime = new Date();

        this.showToast('Session Reset', 'Counter has been reset. Session continues.', 'info');

        setTimeout(() => {
            const inputField = this.template.querySelector('lightning-input');
            if (inputField) {
                inputField.focus();
            }
        }, 100);
    }

    getSessionDuration() {
        if (!this.sessionStartTime) return '0 minutes';

        const now = new Date();
        const diffMs = now - this.sessionStartTime;
        const diffMins = Math.floor(diffMs / 60000);
        const diffSecs = Math.floor((diffMs % 60000) / 1000);

        if (diffMins === 0) {
            return `${diffSecs} second${diffSecs !== 1 ? 's' : ''}`;
        } else if (diffMins < 60) {
            return `${diffMins} minute${diffMins !== 1 ? 's' : ''}`;
        } else {
            const hours = Math.floor(diffMins / 60);
            const mins = diffMins % 60;
            return `${hours}h ${mins}m`;
        }
    }

    handleQrCodeKeyPress(event) {
        if (event.key === 'Enter') {
            event.preventDefault();
            this.handleCheckIn();
        }
    }

    async handleCheckIn() {
        if (!this.sessionActive) {
            this.showToast('Session Not Started', 'Please start a scanning session first.', 'warning');
            return;
        }

        if (!this.qrCodeInput || this.qrCodeInput.trim() === '') {
            this.showToast('Error', 'Please enter or scan a QR code', 'error');
            return;
        }

        this.isProcessing = true;
        this.showResult = false;

        try {
            const result = await checkInRegistrant({ qrCodeValue: this.qrCodeInput.trim() });

            this.lastCheckinResult = result;
            this.showResult = true;

            if (result.success) {
                this.scanCount++;

                if (result.alreadyCheckedIn) {
                    this.showToast(
                        'Already Checked In',
                        `${result.registrantName} was already checked in.`,
                        'warning'
                    );
                } else {
                    this.showToast(
                        'Success!',
                        `${result.registrantName} has been checked in successfully.`,
                        'success'
                    );
                }
            } else {
                this.showToast('Error', result.message, 'error');
            }

            this.qrCodeInput = '';

            const inputField = this.template.querySelector('lightning-input');
            if (inputField) {
                inputField.focus();
            }

        } catch (error) {
            console.error('Error during check-in:', error);
            this.showToast(
                'Error',
                'An unexpected error occurred. Please try again.',
                'error'
            );
        } finally {
            this.isProcessing = false;
        }
    }

    handleClearInput() {
        this.qrCodeInput = '';
        this.showResult = false;
        this.lastCheckinResult = null;

        const inputField = this.template.querySelector('lightning-input');
        if (inputField) {
            inputField.focus();
        }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: variant === 'error' ? 'sticky' : 'dismissable'
        });
        this.dispatchEvent(event);
    }

    get resultCardClass() {
        if (!this.lastCheckinResult) return 'slds-hide';

        if (this.lastCheckinResult.success && !this.lastCheckinResult.alreadyCheckedIn) {
            return 'result-card success-card';
        } else if (this.lastCheckinResult.alreadyCheckedIn) {
            return 'result-card warning-card';
        } else {
            return 'result-card error-card';
        }
    }

    get resultIcon() {
        if (!this.lastCheckinResult) return 'utility:info';

        if (this.lastCheckinResult.success && !this.lastCheckinResult.alreadyCheckedIn) {
            return 'utility:success';
        } else if (this.lastCheckinResult.alreadyCheckedIn) {
            return 'utility:warning';
        } else {
            return 'utility:error';
        }
    }

    get hasResults() {
        return this.showResult && this.lastCheckinResult;
    }

    get showSessionControls() {
        return !this.sessionActive;
    }

    get showActiveSessionControls() {
        return this.sessionActive;
    }

    get sessionDuration() {
        return this.getSessionDuration();
    }

    get isMobileDevice() {
        return !this.scanButtonDisabled;
    }
}

