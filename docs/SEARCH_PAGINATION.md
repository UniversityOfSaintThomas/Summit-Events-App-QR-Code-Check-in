# Pagination for Manual Search Results

## Overview

Manual search results are now **paginated with 5 records per page** to improve usability when many registrants match the search criteria. This prevents overwhelming the screen and makes it easier to scan through results.

---

## Features

### ✅ 5 Records Per Page
- Clean, manageable list
- Easy to scan and select
- No scrolling needed for small result sets

### ✅ Navigation Controls
- **Previous** button (disabled on first page)
- **Page indicator** showing "Page X of Y"
- **Next** button (disabled on last page)

### ✅ Result Count Display
- Shows "1-5 of 23" format
- Updates as you navigate pages
- Total count always visible

### ✅ Auto-Reset
- Pagination resets when performing new search
- Resets when starting/resetting session
- Resets when selecting a result

---

## User Interface

### Search Results with Pagination:

```
┌────────────────────────────────────────┐
│ 🔍 Search by Name                      │
│ First Name: [Smith    ]                │
│ Last Name:  [         ]                │
│ [Search]                                │
│                                         │
│ Results              1-5 of 12         │
│ ┌────────────────────────────────┐    │
│ │ John Smith         [Registered]│    │
│ │ Fall Conference - Morning       │    │
│ └────────────────────────────────┘    │
│ ┌────────────────────────────────┐    │
│ │ Jane Smith         [Registered]│    │
│ │ Fall Conference - Morning       │    │
│ └────────────────────────────────┘    │
│ ┌────────────────────────────────┐    │
│ │ Bob Smith          [Attended]  │    │
│ │ Fall Conference - Afternoon     │    │
│ └────────────────────────────────┘    │
│ ┌────────────────────────────────┐    │
│ │ Alice Smith        [Registered]│    │
│ │ Workshop Series - Session 1     │    │
│ └────────────────────────────────┘    │
│ ┌────────────────────────────────┐    │
│ │ Mike Smith         [Registered]│    │
│ │ Fall Conference - Morning       │    │
│ └────────────────────────────────┘    │
│                                         │
│  [< Previous]  Page 1 of 3  [Next >]  │
└────────────────────────────────────────┘
```

### Page 2:

```
│ Results              6-10 of 12        │
│ ┌────────────────────────────────┐    │
│ │ Sarah Smith        [Registered]│    │
│ └────────────────────────────────┘    │
│ ┌────────────────────────────────┐    │
│ │ David Smith        [Registered]│    │
│ └────────────────────────────────┘    │
│ ... (5 total results on this page)     │
│                                         │
│  [< Previous]  Page 2 of 3  [Next >]  │
```

### Last Page (Partial Results):

```
│ Results              11-12 of 12       │
│ ┌────────────────────────────────┐    │
│ │ Tom Smith          [Registered]│    │
│ └────────────────────────────────┘    │
│ ┌────────────────────────────────┐    │
│ │ Lisa Smith         [Registered]│    │
│ └────────────────────────────────┘    │
│                                         │
│  [< Previous]  Page 3 of 3  [Next >]  │
│                              (disabled) │
```

---

## Implementation Details

### JavaScript Properties

```javascript
// Pagination state
@track currentPage = 1;
pageSize = 5;
```

### Key Methods

**Navigation:**
```javascript
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
```

**Computed Results:**
```javascript
get paginatedResults() {
    const startIndex = (this.currentPage - 1) * this.pageSize;
    const endIndex = startIndex + this.pageSize;
    return this.searchResults.slice(startIndex, endIndex);
}
```

### Key Getters

```javascript
get totalPages() {
    return Math.ceil(this.searchResults.length / this.pageSize);
}

get showPagination() {
    return this.hasSearchResults && this.totalPages > 1;
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
```

---

## Pagination Logic

### When Pagination Appears:
- **Shows:** When total results > 5
- **Hides:** When results ≤ 5 (all fit on one page)

### Button States:
- **Previous disabled:** On page 1
- **Next disabled:** On last page
- **Both enabled:** On middle pages

### Page Calculation:
```
Total Results: 23
Page Size: 5
Total Pages: Math.ceil(23 / 5) = 5 pages

Page 1: Records 1-5
Page 2: Records 6-10
Page 3: Records 11-15
Page 4: Records 16-20
Page 5: Records 21-23 (partial)
```

---

## User Workflow

### Searching with Pagination:

```
1. Enter "Smith" in last name
   ↓
2. Click "Search"
   → Shows "Results 1-5 of 12"
   → Pagination controls appear
   ↓
3. Review first 5 results
   ↓
4. Click "Next" button
   → Shows "Results 6-10 of 12"
   → Now on Page 2 of 3
   ↓
5. Find the right person
   ↓
6. Click result → Confirmation card
   ↓
7. Pagination resets for next search
```

### Edge Cases:

**5 or fewer results:**
- No pagination controls shown
- All results visible immediately

**Exactly 5 results:**
- Shows "1-5 of 5"
- No pagination (only 1 page)

**6 results:**
- Page 1: "1-5 of 6"
- Page 2: "6-6 of 6" (1 result)

---

## Benefits

### 1. Better Usability
✅ Easier to scan 5 results vs 50  
✅ Reduces cognitive load  
✅ Faster to find the right person

### 2. Performance
✅ Only renders 5 results at a time  
✅ No long scrolling lists  
✅ Consistent UI height

### 3. Professional UX
✅ Standard pagination pattern  
✅ Clear navigation controls  
✅ Page indicator shows progress

### 4. Mobile Friendly
✅ Fits on smaller screens  
✅ No scrolling within scrolling  
✅ Touch-friendly buttons

---

## Pagination Behavior

### On Search:
- Resets to page 1
- Calculates total pages
- Shows pagination if needed

### On Previous/Next:
- Updates currentPage
- Re-renders with new slice
- Updates page info display

### On Selection:
- Clears results
- Resets to page 1
- Shows confirmation card

### On Session Reset:
- Clears search
- Resets to page 1
- Clears results

---

## Visual Design

### Layout:
```
┌────────────────────────────────┐
│ [< Previous]  Page X of Y  [Next >] │
└────────────────────────────────┘
```

### Spacing:
- Previous button: Left-aligned
- Page info: Center-aligned
- Next button: Right-aligned

### Button States:
- **Enabled:** Neutral variant, clickable
- **Disabled:** Grayed out, not clickable

### Typography:
- Page info: Small text, subtle
- Button labels: Standard size

---

## Code Changes Summary

### JavaScript:
**Added Properties:**
- `currentPage` (tracks current page)
- `pageSize` (set to 5)

**Added Methods:**
- `handlePreviousPage()`
- `handleNextPage()`

**Added Getters:**
- `paginatedResults` (sliced array)
- `totalPages` (calculated)
- `showPagination` (visibility logic)
- `isOnFirstPage` (button state)
- `isOnLastPage` (button state)
- `pageInfo` (display string)

**Updated Methods:**
- `handleSearchRegistrations()` - Resets currentPage
- `handleSelectRegistration()` - Resets currentPage
- `handleStartSession()` - Resets currentPage
- `handleResetSession()` - Resets currentPage

### HTML Template:
**Changed:**
- Loop uses `paginatedResults` instead of `searchResults`
- Added page info display (right-aligned)

**Added:**
- Pagination controls section
- Previous button
- Page indicator text
- Next button

---

## Testing Scenarios

### ✅ 5 or Fewer Results:
- [ ] Search returns 3 results
- [ ] Verify no pagination controls
- [ ] Verify all results visible

### ✅ Exactly 5 Results:
- [ ] Search returns 5 results
- [ ] Verify "1-5 of 5" display
- [ ] Verify no pagination controls

### ✅ 6-10 Results:
- [ ] Search returns 8 results
- [ ] Verify pagination shows "Page 1 of 2"
- [ ] Click Next
- [ ] Verify shows last 3 results
- [ ] Verify Previous enabled

### ✅ Many Results:
- [ ] Search returns 23 results
- [ ] Verify shows 5 results
- [ ] Navigate through all pages
- [ ] Verify last page shows 3 results

### ✅ Navigation:
- [ ] Verify Previous disabled on page 1
- [ ] Click Next multiple times
- [ ] Verify Next disabled on last page
- [ ] Click Previous to go back

### ✅ Selection:
- [ ] Navigate to page 3
- [ ] Click a result
- [ ] Perform new search
- [ ] Verify resets to page 1

---

## Performance Considerations

### Efficient:
✅ Only renders 5 DOM elements at a time  
✅ Array slicing is fast (native JS)  
✅ No expensive operations on pagination

### Scalable:
✅ Works with 5 results or 500  
✅ Consistent performance  
✅ No scrolling issues

---

## Accessibility

### Keyboard Navigation:
- Tab to Previous button
- Tab to Next button
- Enter/Space to activate

### Screen Readers:
- "Previous" button announced
- "Page 1 of 3" text announced
- "Next" button announced
- Disabled state announced

### Visual Indicators:
- Disabled buttons grayed out
- Current page clearly shown
- Total pages visible

---

## Future Enhancements

### Potential Improvements:

1. **Jump to Page**
   - Dropdown to select page number
   - "Go to page" input

2. **Page Size Options**
   - 5, 10, 20 records per page
   - User preference

3. **Keyboard Shortcuts**
   - Arrow keys for prev/next
   - Numbers for page jump

4. **Result Highlighting**
   - Highlight current page results
   - Different shade for clarity

---

## Summary

✅ **5 records per page**  
✅ **Previous/Next navigation**  
✅ **Page indicator (X of Y)**  
✅ **Result count display (1-5 of 23)**  
✅ **Auto-resets on new search**  
✅ **Hides when ≤5 results**  
✅ **Professional, standard UX**  
✅ **Mobile friendly**  
✅ **No compile errors**

Pagination makes the manual search experience much more manageable and professional, especially for common names that return many matches! 🎉

---

## Page Size Rationale

**Why 5 records?**

✅ **Fits on screen** - No scrolling needed for single page  
✅ **Easy to scan** - 5 results easily readable  
✅ **Quick decisions** - Not overwhelmed with choices  
✅ **Mobile friendly** - Fits on tablet/phone screens  
✅ **Standard practice** - Common in event check-in systems

**Could be adjusted** if needed, but 5 is a good default for this use case.

