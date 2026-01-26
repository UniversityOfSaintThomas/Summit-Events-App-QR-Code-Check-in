# Changelog - Summit Events QR Check-In

## [Unreleased] - 2026-01-26

### Added
- **Context-Aware Component**: LWC now automatically detects when placed on a Summit Events Instance record page
  - Uses URL-based record ID detection for reliability
  - Auto-loads instance details without user interaction
  - Hides date/instance selection when on instance record page
  
- **Record Page Support**: Component meta.xml configured with `objects` specification for Summit Events Instance
  - Supports both desktop (Large) and mobile (Small) form factors
  - Works on Salesforce Mobile App

- **New Apex Method**: `getEventInstanceById()` to retrieve instance details by ID

### Changed
- **Console Logging**: Removed verbose debug logs, keeping only essential error logging
- **Property Handling**: Implemented custom setters for `recordId` and `objectApiName` to handle async framework property setting
- **Template Logic**: Conditional rendering based on `isOnInstanceRecordPage` getter

### Fixed
- Component now properly detects record context in all environments
- Form factors maintained across all target configurations to prevent deployment errors

### Documentation
- **Reorganized docs folder**: 
  - Consolidated main documentation (8 files)
  - Archived historical/redundant docs to `/docs/archive/` (5 files)
  - Updated README.md with current feature set and context-aware deployment
  
- **Core Documentation**:
  - `README.md` - Main documentation index with Quick Start
  - `QUICK-START.md` - 2-minute getting started guide
  - `INSTALLATION-PACKAGE.md` - Package installation instructions
  - `USER-GUIDE.md` - Complete user instructions
  - `CAMERA-TROUBLESHOOTING.md` - Camera access troubleshooting
  - `LWS-ENABLEMENT-GUIDE.md` - Lightning Web Security setup
  - `DEVELOPER-SETUP.md` - CumulusCI development workflow
  - `ARCHITECTURE.md` - Technical architecture
  
- **Archived Documentation**:
  - `CODE-OPTIMIZATIONS.md` - Historical optimization notes
  - `DEPLOYMENT-CAMERA-FIX.md` - Specific deployment guide (superseded)
  - `LOCKER-SERVICE-CAMERA-ISSUE.md` - Locker Service details (superseded by LWS guide)
  - `README-OLD.md` - Previous README (v0.1)
  - `V0.1-RELEASE-NOTES.md` - Initial release notes

## Technical Details

### URL-Based Record Detection
The component uses multiple URL pattern matching strategies to extract the record ID:
- `/r/[ObjectName]/[ID]/view` - Standard Lightning Experience pattern
- `/[ID]/view` - Alternative view pattern
- `/[ID]?` - Query parameter pattern
- `/[ID]$` - End-of-URL pattern

This approach is more reliable than waiting for framework `@api` properties in certain environments.

### Deployment Configuration
The meta.xml now includes:
```xml
<targetConfig targets="lightning__RecordPage">
    <objects>
        <object>summit__Summit_Events_Instance__c</object>
    </objects>
    <supportedFormFactors>
        <supportedFormFactor type="Large"/>
        <supportedFormFactor type="Small"/>
    </supportedFormFactors>
</targetConfig>
```

This configuration enables the framework to provide record context and supports mobile form factors.

## Migration Notes

### For Existing Deployments
No breaking changes. Component will:
- Continue to work on App/Home/Community pages with manual instance selection
- Automatically gain context-awareness when placed on Instance record pages
- No configuration changes required

### For New Deployments
Recommended deployment approach:
1. Place component on Summit Events Instance record page layouts for streamlined check-in
2. Optionally add to App or Home pages for central check-in hub with instance switching

## Known Issues
None at this time.

## Next Release Planning
Consider for future versions:
- Multi-instance check-in from single page
- Check-in history and reporting
- Custom field mapping for check-in data
- Batch check-in operations
