# Deployment Order Guide

## Issue
When deploying all changes at once, you may encounter this error:
```
Unable to find Apex action method referenced as 'summitEventsCheckin.getEventInstancesByDate'
```

This happens because the LWC tries to validate against the org before the Apex class is deployed.

---

## Solution: Deploy in Two Phases

### Phase 1: Deploy Apex Classes First

Deploy only the Apex classes to make the new method available:

**Files to deploy:**
- `force-app/main/default/classes/summitEventsCheckin.cls`
- `force-app/main/default/classes/summitEventsCheckin.cls-meta.xml`
- `force-app/main/default/classes/summitEventsCheckinTest.cls`
- `force-app/main/default/classes/summitEventsCheckinTest.cls-meta.xml`

**Using Salesforce CLI:**
```bash
sf project deploy start --source-dir force-app/main/default/classes
```

**Or using specific files:**
```bash
sf project deploy start --source-dir force-app/main/default/classes/summitEventsCheckin.cls force-app/main/default/classes/summitEventsCheckinTest.cls
```

**Wait for deployment to complete successfully.**

---

### Phase 2: Deploy LWC Components

After the Apex classes are deployed, deploy the LWC:

**Files to deploy:**
- `force-app/main/default/lwc/summitEventsQrCheckin/`

**Using Salesforce CLI:**
```bash
sf project deploy start --source-dir force-app/main/default/lwc/summitEventsQrCheckin
```

---

## Alternative: Deploy Everything (May Work)

Sometimes deploying everything works fine:

```bash
sf project deploy start --source-dir force-app/main/default
```

If you get the LWC error, fall back to the two-phase approach above.

---

## Verification Steps

After deployment:

1. **Verify Apex deployed:**
   ```bash
   sf apex list
   ```
   Should show `summitEventsCheckin`

2. **Run Apex tests:**
   ```bash
   sf apex run test --class-names summitEventsCheckinTest --result-format human
   ```
   All 20 tests should pass ✅

3. **Verify LWC deployed:**
   - Open the org
   - Navigate to Setup → Lightning Components
   - Search for `summitEventsQrCheckin`
   - Should be listed

4. **Test the component:**
   - Open an Experience Cloud site or add to a page
   - Verify date picker appears
   - Select a date with event instances
   - Verify dropdown populates
   - Start scanning session

---

## Common Issues

### Issue: "Field does not exist: summit__Active__c"
**Status:** ✅ FIXED  
This was removed from the code.

### Issue: "Unable to find Apex action method"
**Solution:** Deploy Apex first (Phase 1), then LWC (Phase 2)

### Issue: Test failures
**Solution:** Ensure test data includes instances with dates matching `Date.today().addDays(1)`

---

## Summary

✅ All compile errors fixed  
✅ Test class updated  
✅ Active field removed  
⚠️ Deploy Apex classes FIRST, then LWC components

This ensures the Apex method exists before the LWC tries to validate against it.

