import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
import { loadScript } from 'lightning/platformResourceLoader';
import jsQR from '@salesforce/resourceUrl/jsQR';
import lookupRegistrant from '@salesforce/apex/summitEventsCheckin.lookupRegistrant';
import checkInRegistrant from '@salesforce/apex/summitEventsCheckin.checkInRegistrant';
import searchRegistrations from '@salesforce/apex/summitEventsCheckin.searchRegistrations';
import getEventInstancesByDate from '@salesforce/apex/summitEventsCheckin.getEventInstancesByDate';
import getTotalAttendedCount from '@salesforce/apex/summitEventsCheckin.getTotalAttendedCount';
import undoCheckIn from '@salesforce/apex/summitEventsCheckin.undoCheckIn';

export default class SummitEventsQrCheckin extends LightningElement {
    @api title = 'Event Check-In';
    @api checkinStatus = 'Attended'; // Configurable status value for check-in
    @track qrCodeInput = '';
    @track isProcessing = false;
    @track lastCheckinResult = null;
    @track showResult = false;
    @track pendingCheckin = null; // Holds registration awaiting check-in confirmation
    @track scanCount = 0;
    @track totalAttendedCount = 0; // Total attended for the instance
    @track sessionActive = false;
    @track sessionStartTime = null;
    @track showCameraScanner = false;

    // Event instance selection properties
    @track selectedDate = '';
    @track selectedInstanceId = '';
    @track instanceOptions = [];
    @track loadingInstances = false;
    @track noInstancesFound = false;

    // Manual lookup properties (now inline)
    @track firstName = '';
    @track lastName = '';
    @track email = '';
    @track searchResults = [];
    @track isSearching = false;
    @track selectedRegistration = null;
    @track searchPerformed = false;

    // Pagination properties
    @track currentPage = 1;
    pageSize = 5;

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
        this.checkCameraSupport();
    }

    checkCameraSupport() {
        console.log('🔍 Checking camera support...');
        console.log('  - Protocol:', window.location.protocol);
        console.log('  - Secure context:', window.isSecureContext);
        console.log('  - navigator.mediaDevices:', !!navigator.mediaDevices);
        console.log('  - getUserMedia:', !!(navigator.mediaDevices && navigator.mediaDevices.getUserMedia));

        if (window.isSecureContext && navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
            console.log('✅ Camera support detected');
        } else {
            console.warn('⚠️ Camera support not available');
            if (!window.isSecureContext) {
                console.warn('  - Reason: Not a secure context (requires HTTPS)');
            }
            if (!navigator.mediaDevices) {
                console.warn('  - Reason: navigator.mediaDevices not available');
            }
        }
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

    async handleDateChange(event) {
        this.selectedDate = event.target.value;
        this.selectedInstanceId = '';
        this.instanceOptions = [];
        this.noInstancesFound = false;

        if (!this.selectedDate) {
            return;
        }

        this.loadingInstances = true;

        try {
            const instances = await getEventInstancesByDate({ selectedDate: this.selectedDate });

            if (instances && instances.length > 0) {
                this.instanceOptions = instances.map(inst => ({
                    label: inst.label,
                    value: inst.value
                }));
                this.noInstancesFound = false;
            } else {
                this.instanceOptions = [];
                this.noInstancesFound = true;
            }
        } catch (error) {
            console.error('Error loading event instances:', error);
            this.showToast('Error', 'Failed to load event instances. Please try again.', 'error');
            this.instanceOptions = [];
            this.noInstancesFound = true;
        } finally {
            this.loadingInstances = false;
        }
    }

    handleInstanceChange(event) {
        this.selectedInstanceId = event.target.value;
    }

    async refreshTotalAttendedCount() {
        if (!this.selectedInstanceId) {
            this.totalAttendedCount = 0;
            return;
        }

        try {
            const count = await getTotalAttendedCount({
                instanceId: this.selectedInstanceId,
                checkinStatus: this.checkinStatus
            });
            this.totalAttendedCount = count || 0;
        } catch (error) {
            console.error('Error refreshing attended count:', error);
            this.totalAttendedCount = 0;
        }
    }

    handleQrCodeChange(event) {
        this.qrCodeInput = event.target.value;
    }

    async handleStartSession() {
        if (!this.selectedInstanceId) {
            this.showToast('Instance Required', 'Please select an event instance before starting the session.', 'warning');
            return;
        }

        this.sessionActive = true;
        this.sessionStartTime = new Date();
        this.scanCount = 0;
        this.showResult = false;
        this.lastCheckinResult = null;
        this.pendingCheckin = null;
        this.qrCodeInput = '';
        this.firstName = '';
        this.lastName = '';
        this.email = '';
        this.searchResults = [];
        this.searchPerformed = false;
        this.currentPage = 1;

        // Load initial total attended count
        await this.refreshTotalAttendedCount();

        this.showToast('Session Started', 'Scanning session is now active. Ready to check in registrants.', 'success');
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
        console.log('🎥 Camera scan initiated');
        console.log('Session active:', this.sessionActive);
        console.log('Secure context:', window.isSecureContext);
        console.log('navigator.mediaDevices available:', !!navigator.mediaDevices);
        console.log('getUserMedia available:', !!(navigator.mediaDevices && navigator.mediaDevices.getUserMedia));
        console.log('jsQR loaded:', this.jsQRLoaded);
        console.log('jsQR library:', !!this.jsQRLibrary);

        if (!this.sessionActive) {
            this.showToast('Session Not Started', 'Please start a scanning session first.', 'warning');
            return;
        }

        // Auto-detect device and use appropriate scanner
        const isSalesforceMobile = this.myScanner != null && this.myScanner.isAvailable();

        if (isSalesforceMobile) {
            // On Salesforce Mobile App - use native scanner
            console.log('Detected Salesforce Mobile App - using native scanner');
            this.handleScanWithCamera();
            return;
        }

        // On desktop/browser - use jsQR camera
        // Check if running in secure context (HTTPS or localhost)
        if (!window.isSecureContext) {
            this.showToast(
                'Secure Connection Required',
                'Camera access requires HTTPS. Please access this page via HTTPS or use manual search.',
                'error'
            );
            console.error('❌ Camera requires secure context (HTTPS). Current protocol:', window.location.protocol);
            return;
        }

        // Check for mediaDevices API
        if (!navigator.mediaDevices) {
            this.showToast(
                'Camera API Not Available',
                'Camera API is not available in your browser. Please use manual search.',
                'error'
            );
            console.error('❌ navigator.mediaDevices is not available');
            return;
        }

        if (!navigator.mediaDevices.getUserMedia) {
            this.showToast(
                'getUserMedia Not Supported',
                'Your browser does not support getUserMedia. Please use manual search or try Chrome/Firefox/Edge.',
                'error'
            );
            console.error('❌ navigator.mediaDevices.getUserMedia is not available');
            return;
        }

        if (!this.jsQRLoaded || !this.jsQRLibrary) {
            this.showToast(
                'Scanner Loading',
                'QR code scanner is still loading. Please try again in a moment.',
                'info'
            );
            console.warn('⚠️ jsQR library not loaded yet');
            return;
        }

        console.log('✅ All checks passed - starting camera scanner');
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
        this.pendingCheckin = null;
        this.qrCodeInput = '';
        this.firstName = '';
        this.lastName = '';
        this.email = '';
        this.searchResults = [];
        this.searchPerformed = false;
        this.currentPage = 1;
        this.sessionStartTime = new Date();

        this.showToast('Session Reset', 'Counter has been reset. Session continues.', 'info');
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
        this.pendingCheckin = null;
        this.lastCheckinResult = null;

        try {
            // Lookup registration without checking in
            const result = await lookupRegistrant({
                qrCodeValue: this.qrCodeInput.trim(),
                instanceId: this.selectedInstanceId,
                checkinStatus: this.checkinStatus
            });

            if (result.success) {
                // Store pending registration for confirmation
                this.pendingCheckin = result;
                this.showResult = true;

                if (result.alreadyCheckedIn) {
                    this.showToast(
                        'Already Checked In',
                        `${result.registrantName} was already checked in.`,
                        'info'
                    );
                }
            } else {
                this.showToast('Error', result.message, 'error');
            }

            this.qrCodeInput = '';

        } catch (error) {
            console.error('Error during lookup:', error);
            this.showToast(
                'Error',
                'An unexpected error occurred. Please try again.',
                'error'
            );
        } finally {
            this.isProcessing = false;
        }
    }

    async handleConfirmCheckIn() {
        if (!this.pendingCheckin) {
            return;
        }

        this.isProcessing = true;

        try {
            const result = await checkInRegistrant({
                qrCodeValue: this.pendingCheckin.registrationId,
                instanceId: this.selectedInstanceId,
                checkinStatus: this.checkinStatus
            });

            this.lastCheckinResult = result;

            if (result.success && !result.alreadyCheckedIn) {
                this.scanCount++;
                this.showToast(
                    'Success!',
                    `${result.registrantName} has been checked in successfully.`,
                    'success'
                );
                // Refresh total attended count
                await this.refreshTotalAttendedCount();
            }

            // Clear pending check-in
            this.pendingCheckin = null;
            this.showResult = false;

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

    handleCancelCheckIn() {
        this.pendingCheckin = null;
        this.showResult = false;
        this.lastCheckinResult = null;
    }

    async handleUndoCheckIn() {
        if (!this.pendingCheckin || !this.pendingCheckin.registrationId) {
            return;
        }

        this.isProcessing = true;

        try {
            const result = await undoCheckIn({
                registrationId: this.pendingCheckin.registrationId,
                instanceId: this.selectedInstanceId,
                checkinStatus: this.checkinStatus
            });

            if (result.success) {
                this.showToast(
                    'Check-In Undone',
                    `${result.registrantName} has been reverted to Registered status.`,
                    'success'
                );

                // Decrement scan count if it was from this session
                if (this.scanCount > 0) {
                    this.scanCount--;
                }

                // Refresh total attended count
                await this.refreshTotalAttendedCount();

                // Clear pending check-in
                this.pendingCheckin = null;
                this.showResult = false;
            } else {
                this.showToast('Error', result.message, 'error');
            }

        } catch (error) {
            console.error('Error undoing check-in:', error);
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

    // Manual Lookup Methods (Inline)
    handleFirstNameChange(event) {
        this.firstName = event.target.value;
    }

    handleLastNameChange(event) {
        this.lastName = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    async handleSearchRegistrations() {
        if (!this.sessionActive) {
            this.showToast('Session Not Started', 'Please start a scanning session first.', 'warning');
            return;
        }

        if ((!this.firstName || this.firstName.trim() === '') &&
            (!this.lastName || this.lastName.trim() === '') &&
            (!this.email || this.email.trim() === '')) {
            this.showToast('Search Required', 'Please enter at least first name, last name, or email', 'warning');
            return;
        }

        this.isSearching = true;
        this.searchResults = [];
        this.selectedRegistration = null;
        this.searchPerformed = false;
        this.currentPage = 1;

        try {
            const results = await searchRegistrations({
                firstName: this.firstName,
                lastName: this.lastName,
                email: this.email,
                instanceId: this.selectedInstanceId,
                checkinStatus: this.checkinStatus
            });

            this.searchResults = results;
            this.searchPerformed = true;

            if (results.length === 0) {
                this.showToast('No Results', 'No registrations found matching the criteria.', 'info');
            }

        } catch (error) {
            console.error('Error during registration search:', error);
            this.showToast('Error', 'An unexpected error occurred. Please try again.', 'error');
        } finally {
            this.isSearching = false;
        }
    }

    handleSelectRegistration(event) {
        const registrationId = event.currentTarget.dataset.id;

        if (!registrationId) {
            console.log('No registration ID found in click event');
            return;
        }

        console.log('Registration selected:', registrationId);

        // Clear search results and reset search form
        this.searchResults = [];
        this.searchPerformed = false;
        this.currentPage = 1;
        this.firstName = '';
        this.lastName = '';
        this.email = '';

        // Set the registration ID and trigger check-in lookup
        this.qrCodeInput = registrationId;
        this.handleCheckIn();
    }

    handlePreviousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
        }
    }

    handleNextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
        }
    }

    get isSearchingOrProcessing() {
        return this.isSearching || this.isProcessing;
    }

    get hasSearchResults() {
        return this.searchResults && this.searchResults.length > 0;
    }

    get showNoResults() {
        return this.searchPerformed && !this.isSearching && this.searchResults.length === 0;
    }

    // Pagination getters
    get paginatedResults() {
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        return this.searchResults.slice(start, end);
    }

    get totalPages() {
        return Math.ceil(this.searchResults.length / this.pageSize);
    }

    get showPagination() {
        return this.hasSearchResults && this.totalPages > 1;
    }

    get hasPreviousPage() {
        return this.currentPage > 1;
    }

    get hasNextPage() {
        return this.currentPage < this.totalPages;
    }

    get isOnFirstPage() {
        return this.currentPage === 1;
    }

    get isOnLastPage() {
        return this.currentPage === this.totalPages;
    }

    get pageInfo() {
        const start = (this.currentPage - 1) * this.pageSize + 1;
        const end = Math.min(this.currentPage * this.pageSize, this.searchResults.length);
        return `${start}-${end} of ${this.searchResults.length}`;
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

    get hasPendingCheckin() {
        return this.showResult && this.pendingCheckin !== null;
    }

    get hasCompletedCheckin() {
        return this.lastCheckinResult !== null && this.pendingCheckin === null;
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

    get showInstancePicker() {
        return !this.loadingInstances && this.instanceOptions.length > 0;
    }

    get isStartButtonDisabled() {
        return !this.selectedInstanceId || this.selectedInstanceId === '';
    }

    get registrationRecordUrl() {
        if (this.pendingCheckin && this.pendingCheckin.registrationId) {
            return `/${this.pendingCheckin.registrationId}`;
        }
        return '#';
    }

    get formattedEventTime() {
        if (this.pendingCheckin && this.pendingCheckin.instanceStartTime) {
            // Parse the time string (format: HH:mm:ss.SSS or HH:mm:ss)
            const timeStr = this.pendingCheckin.instanceStartTime.toString();
            const parts = timeStr.split(':');
            if (parts.length >= 2) {
                let hours = parseInt(parts[0], 10);
                const minutes = parts[1];
                const ampm = hours >= 12 ? 'PM' : 'AM';
                hours = hours % 12;
                hours = hours ? hours : 12; // 0 should be 12
                return `${hours}:${minutes} ${ampm}`;
            }
        }
        return '';
    }
}
