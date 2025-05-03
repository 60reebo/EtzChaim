# README – Hishtalshelut.Rules.Analysis

This directory contains **pure investigation and analysis functions** for the project. These functions are designed to check, analyze, and explain core phenomena in the model, based on the textual and conceptual sources of the project.

Each file in this directory corresponds to a specific type of investigation ("חֲקִירָה") and includes:
- A clear explanation of the investigation's purpose
- A direct quote from the source text
- A simple explanation in plain language
- The functions themselves (Agda code)
- How to use each function

---

## Investigations and Functions

### 1. AttributeManifestation.agda
**Investigation:** Are all divine names/attributes manifested in creation?
- **Source Quote:**
  > "...אם לא היה מוציא פעולותיו וכוחותיו לידי פועל ומעשה לא היה כביכול נקרא שלם..."
- **Plain Explanation:** Only when all divine names/attributes are actualized in creation, is the divine completeness revealed.
- **Functions:**
  - `allAttributesManifested : List Attribute → List Attribute → Bool`  
    Checks if all possible attributes have been manifested.
  - `missingAttributes : List Attribute → List Attribute → List Attribute`  
    Returns the list of attributes that are still missing.
- **Usage:**
  - Use `allAttributesManifested` with the full list of attributes and the manifested ones.
  - Use `missingAttributes` to get the missing ones.

---

### 2. WorldOrder.agda
**Investigation:** Is the order of world emanation correct, and what is the reason for each world's creation time?
- **Source Quote:**
  > "...ולא היה אפשר להקדים או לאחר בריאת עוה"ז, כי כל עולם ועולם נברא אחר בריאת עולם שלמעלה ממנו..."
- **Plain Explanation:** Each world is created only after the one above it, so the order is necessary and cannot be changed.
- **Functions:**
  - `isWorldOrderValid : List WorldInstance → Bool`  
    Checks if the order of creation is valid.
  - `explainWorldCreation : List WorldInstance → List String`  
    Returns textual explanations for the creation order.
- **Usage:**
  - Use `isWorldOrderValid` to check the order.
  - Use `explainWorldCreation` to get explanations for each world.

---

### 3. WorldTimeAnalysis.agda
**Investigation:** Calculate the creation times of all worlds, working backwards from the known creation time of our world.
- **Source Quote:**
  > "...אפשר...לחשב אחורה...ולדעת קודם בריאת העולם מתי נברא כל עולם עד להסקה מתי היה זמן הצמצום..."
- **Plain Explanation:** If you know when our world was created, you can calculate when each previous world was created, all the way back to the tzimtzum.
- **Function:**
  - `calcCreationTimesBackward : List WorldStep → String → ℕ → List (String × ℕ)`  
    Calculates the creation time for each world based on intervals.
- **Usage:**
  - Use `calcCreationTimesBackward` with the list of worlds, the known world name, and its creation time.

---

### 4. Helpers.agda
**Investigation:** General helper functions for dependency checking and chain building.
- **Plain Explanation:**
  - Ensure there are no dependency loops.
  - Build a sorted chain of worlds.
- **Functions:**
  - `checkHierarchicalDependencies : List (String × Maybe String) → Bool`
  - `buildWorldChain : List (String × Maybe String) → List String`
- **Usage:**
  - Use these helpers in other analyses or for validation.

---

## General Notes
- All functions here are **pure** (stateless, no side effects).
- Analyses are based on the conceptual logic of the project and textual sources.
- You can import these modules from the Rules layer or above.

---

## עברית – תקציר

תיקיה זו מרכזת את כל פונקציות החקירה הטהורות (pure) של המערכת:
- כל קובץ עוסק בחקירה עקרונית אחת (שלמות הכינויים, סדר השתלשלות, חישוב זמני בריאה וכו').
- כל חקירה כוללת הסבר, ציטוט מהמקור, הסבר בלשון קלה, ופונקציות Agda ליישום.
- ניתן לייבא את הפונקציות מכל שכבת RULES ומעלה.

לשאלות, דוגמאות או הרחבות – ראה את הקבצים עצמם או פנה למפתחי המערכת.
