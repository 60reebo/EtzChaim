# EtzChaim — סימולציית השתלשלות עולמות על פי הקבלה
[![CI](https://github.com/60reebo/EtzChaim/actions/workflows/ci.yml/badge.svg)](https://github.com/60reebo/EtzChaim/actions/workflows/ci.yml)

פרויקט זה מדמה את תהליך השתלשלות האור והעולמות, מהאינסוף ועד תיקון BYA, באמצעות קוד פורמלי בשפת Agda.

---

## Getting Started
### Prerequisites
- GHC >= 9.6.7
- Cabal >= 3.8
- Agda >= 2.6 ו־Agda Standard Library
- GNU Make

### Build & Run
1. קומפילציה של קבצי Agda:
   ```bash
   make check    # Compile Agda modules
   ```
2. בניית קוד Haskell (executables ו־tests):
   ```bash
   cabal update
   cabal build --enable-tests
   ```
3. הרצת סימולציות:
   ```bash
   cabal run etzchaim -- עגולים
   cabal run etzchaim -- צמצום 3       # ברירת מחדל עומק=3
   cabal run etzchaim -- גיאומטריה
   cabal run etzchaim -- הכל
   ```
4. הרצת כל הבדיקות:
   ```bash
   cabal test --color=always
   ```
---

## תוכן העניינים
- [Architecture Overview](README_ARCHITECTURE.md)
- [Layers](README.layers.md)
- [Domain](src/Hishtalshelut/Domain/README.md)
- [State](src/Hishtalshelut/State/README.md)
- [Rules](src/Hishtalshelut/Rules/README.md)
- [Engine](src/Hishtalshelut/Engine/README.md)
- [Runtime](src/Hishtalshelut/Runtime/README.md)

## תיעוד חדש
לתיעוד מקיף יותר של לוגיקת האורות והסימולציה, ראה:
- [מתמטיקה ולוגיקה](MATHEMATICS.md) - תיעוד מתמטי מפורט של הלוגיקות
- [דוגמאות קוד](EXAMPLES.md) - דוגמאות שימוש בסימולטור
- [ארכיטקטורה מפורטת](ARCHITECTURE.md) - פירוט מבנה המערכת

---

## מבנה המודל והקוד

### שלבי ההשתלשלות
1. **אור אינסוף (Ein Sof)** — מצב ראשוני של אור אינסופי, מיוצג כ-∞.
2. **צמצום (Tzimtzum)** — מעבר מאינסוף לאור 0 (ריקנות).
3. **הכנסת הקו (Kav)** — הכנסת אור ראשון ממשי (1) לחלל.
4. **עקודים (Akudim)** — דינמיקת אור וכלים ראשונית, מעבר בין ספירות.
5. **נקודים (Nekudim)** — שבירת הכלים, פיזור ניצוצות.
6. **אצילות, BYA** — תיקון, בניית כלים חדשים, זרימת שפע, דינמיקה מחזורית.

### מבנה התיקיות
- `src/Hishtalshelut/Stage/` — שלבים ראשוניים (אין סוף, צמצום, קו)
- `src/Hishtalshelut/Olam/` — עולמות עקודים, נקודים, אצילות, BYA
- `src/Hishtalshelut/Simulation.agda` — פונקציות שרשור ותזמון בין השלבים
- `src/Hishtalshelut/Core.agda` — טיפוסים בסיסיים (ספירות, אור, כלי)
- `src/Hishtalshelut/Lib/EqDec.agda` — השוואות דצידביליות
- `src/Main.agda` — קובץ ראשי להרצה ובדיקות

---

## עקרונות הייצוג המתמטי של אורות וכלים במערכת

### 1. היררכיה עשרונית וספירות
- כל עולם מורכב מעשר ספירות, וכל ספירה מורכבת מעשר ספירות פנימיות (עקרון "ספירות שבספירה").
- כל מעבר בין רמות (עולם → ספירה → ספירה פנימית) הוא כפולה/חלוקה ב-10.
- אפשר לייצג את מבנה הספירות כעץ רקורסיבי בעומק שרירותי.

### 2. חישוב אור/כלי לפי רמות עשרוניות
- כל אור/כלי מיוצג כרמת עשרונית (log₁₀), לדוג' 0=1, 1=10, 2=100, 3=1000.
- מעבר אור בין רמות הוא מעבר ברקורסיה על עץ הספירות.
- קיבולת הכלי והאור הנקלט נמדדים לפי רמות, לא ערכים מוחלטים.

### 3. עיקרון הגימטריה והשורש
- בגימטריה, 1, 10, 100, 1000 וכו' הם אותה איכות שורשית (mod 9).
- אפשר להגדיר פונקציות שמחשבות את "שורש הגימטריה" של כל ערך אור/כלי (n mod 9).
- זה מאפשר לראות את כל ההשתלשלות כ"אותה איכות" ברמות שונות.

### 4. דינמיקה של שבירה, ניצוצות ותיקון
- כלי שנשבר מפזר את האור ל"ניצוצות" (יחידות אור קטנות), אותן אפשר לאסוף ולתקן.
- שבירה/תיקון/בירור מתבצעים ברמת כל ספירה פנימית.
- אפשר להגדיר פונקציות מעבר (step) שמעדכנות את מצב הכלי, הניצוצות והאור.

### 5. הצעות למימוש פורמלי (Agda-style)
- ייצוג עץ ספירות רקורסיבי:
  ```agda
  record Sefirah : Set where
    constructor mkSefirah
    field
      name     : SefirahName
      ohr      : ℕ
      kelim    : ℕ
      children : List Sefirah
  ```
- ייצוג אור/כלי כרמה עשרונית:
  ```agda
  record Ohr : Set where
    constructor mkOhr
    field
      level : ℕ   -- לדוג' 0=1, 1=10, 2=100, 3=1000
  ohrValue : Ohr → ℕ
  ohrValue o = 10 ^ (Ohr.level o)
  ```
- חישוב שורש גימטרי:
  ```agda
  gematriaRoot : ℕ → ℕ
  gematriaRoot n with n mod 9
  ... | 0 = 9
  ... | m = m
  ```
- פונקציות מעבר דינמיות (שבירה, תיקון, מעבר בין רמות) יפעלו על רמות עשרוניות.

### 6. יתרונות הגישה
- אחידות מתמטית בין כל שלבי ההשתלשלות.
- פשטות חישובית והרחבה קלה.
- קשר ישיר לגימטריה ולשפה הקבלית.
- אפשרות להרחבה דינמית של המערכת והוספת מורכבויות (פרצופים, קליפות, בירור, וכו').

---

## עקרונות המימוש
- **כל שלב מייצג טרנספורמציה מתמטית:**
  - אין סוף → 0 → 1 → מעבר דינמי בין ערכים
- **מעבר בין שלבים:** כל שלב מקבל את המצב הסופי של השלב הקודם.
- **המודלים של Akudim/Nekudim/Atzilut/BYA** מעבדים אור, כלים, שבירה ותיקון.

---

## Ordinal & Cardinal: טרנספיניטיים

- **Ordinal**: כעת תומך ב־ω, ω², Ω (limit, limitTr), כולל דוגמאות קוד:
  ```agda
  omega : Ordinal ℓ
  omega² : Ordinal ℓ
  Omega : Ordinal ℓ
  ```
  limit יוצר גבול על ℕ, limitTr יוצר גבול טרנספיניטי.
- **Cardinal**: תומך ב־aleph0, aleph1, alephOmega, limitCard:
  ```agda
  aleph0 : Cardinal ℓ
  alephOmega : Cardinal ℓ
  ```
- **חישובים נתמכים**: חיבור, כפל, חזקה, בדיקות סדר, הצגה טקסטואלית.
- **מה חסר**: הוכחות קונסטרוקטיביות, בדיקות אוטומטיות, הרחבה לאינפיניטסימלים.

### דינמיקות פורמליות: שבירה, ניצוצות ותיקון עם ערכים אינסופיים

המערכת תומכת בתרחישים בהם כלי פוגש אור אינסופי (או טרנספיניטי), וכתוצאה מכך מתבצעת שבירה, פיזור ניצוצות ותיקון — גם עבור ערכי aleph0, alephOmega וכו'.

#### דוגמה Agda: שבירה ואיסוף ניצוצות עם אינסוף
```agda
open import Hishtalshelut.Domain.Math.Cardinal
open import Hishtalshelut.Domain.CoreTypes.Light
open import Hishtalshelut.Domain.CoreTypes.Keli

keliWithInfiniteLight : Keli
keliWithInfiniteLight = mkKeli sefirahId InnerVessel (record {}) (fin 5)
  (mkLight aleph0 (succ zero) Nefesh InnerVessel "test" 0) nothing

-- בדיקה עקרונית (פוסטולטיבית):
postulate
  breakVessel : Keli → Bool
  collectSparks : Keli → List Light
  repairVessel : Keli → Keli

_ : Bool
_ = breakVessel keliWithInfiniteLight  -- אמור להחזיר true
_ = (collectSparks keliWithInfiniteLight) ≠ []
_ = let repaired = repairVessel keliWithInfiniteLight in
    leqCard (power (content repaired)) (capacity repaired)
```

> **הערה:** התמיכה בפורמליזם לא סופי מאפשרת לחקור ולדמות תהליכים של שבירה/תיקון גם בעולמות אינסופיים, ולבצע בדיקות קצה פורמליות על כל שכבות המערכת.

### דיאגרמה טקסטואלית
```
zero → succ → ... → limit(ℕ) = ω → limitTr(ω, f) = Ω
```

## טכניקות וחישובים במערכת

### מה קיים
- מערכת אורדינלית: `ordinalLevels`, `ordinalTrace`, `ordinalTraceText`.
- מערכת קרדינלית: `cardinalLevels`, `cardinalTrace`, `cardinalTraceText`.
- פונקציות הצגה: `showOrdinal`, `showCardinal`, `showOrdinalTriple`, `showCardinalTriple`.
-עקיבה טקסטואלית ו־3D geometry trace.

### מה חסר
- בדיקות יחידה ואימות פורמלי של חישובי Ordinal ו־Cardinal.
- הרחבת טווח Ordinal לטרנספיניטיים ואלגברה פורמלית של אורות.
- מודל עומק רקורסיבי פרמטרי עם שדה `position` ו-`connections`.
- מודל טופולוגי של עולמות (רציפות, מרחק, שכנות).

### צעדים הבאים
- הגדרת פרופרטיס ב-Agda לבדיקת מאפייני יסוד.
- יצירת מודולי בדיקה ב־Haskell/Agda.
- תיעוד מפורט של הטכניקות והגישות ב־README_ARCHITECTURE.md וב־README.layers.md.
- השלמת המודולים החסרים ושילובם ב־pipeline הכולל.

---

## תוכנית עבודה להשלמת המערכת

### 1. שרשור תהליכים — מעבר מצב בין שלבים
- [ ] לכתוב פונקציה אחת שמריצה את כל השרשרת: EinSof → Tzimtzum → Kav → Akudim → Nekudim → Atzilut/BYA
- [ ] להגדיר טיפוס מצב כולל (State) שמכיל את כל המידע הדרוש בכל שלב

### 2. מימוש דינמי של Akudim, Nekudim, Atzilut
- [ ] להשלים פונקציות step ב-Akudim: מעבר אור, יצירת כלי, מעבר בין ספירות
- [ ] להשלים לוגיקת שבירת כלים בנקודים: כאשר האור גבוה מהקיבולת — שבירה, פיזור ניצוצות
- [ ] להוסיף פונקציות תיקון ואיסוף ניצוצות
- [ ] לוודא שכל שלב מקבל קלט מתאים מהשלב הקודם

### 3. חיבור בין שלבים
- [ ] כל שלב צריך לקבל ולהחזיר מצב הכולל ערכי אור, כלי, ניצוצות וכו'.
- [ ] להגדיר פונקציות מעבר בין שלבים (transition functions)

### 4. השלמת פונקציות Placeholder
- [ ] להשלים את כל הפונקציות שמסומנות כ-`{!!}` או שמחזירות ערך דמה
- [ ] דגש על: מעבר אור בין ספירות, חישוב קיבולת, שבירה, איסוף ניצוצות

### 5. בדיקות וסימולציה
- [ ] להוסיף פונקציות בדיקה שמריצות את כל השרשרת ומדפיסות את ערכי האור/הכלים/הניצוצות בכל שלב
- [ ] לבדוק שהמערכת מתנהגת כפי שמצופה (שבירה, תיקון, זרימת אור)

### 6. דוקומנטציה
- [ ] להוסיף הערות/דוקומנטציה לכל פונקציה עיקרית ולכל שלב
- [ ] להסביר בקצרה בכל קובץ מה הלוגיקה של השלב

---

## איך להתחיל
1. התקן את Agda.
2. פתח את הקבצים ב-`src/` והתחל לפתח את המודלים.
3. להרצה/בדיקה: השתמש ב-`Main.agda`.

---

## תיעוד
כל התיעוד מרוכז בתיקיית `docs`: [docs/README.md](docs/README.md)

בהצלחה במסע ההשתלשלות!

## ספריית תרחישים והרצה (Haskell)

הקבצים המרכזיים:
- `src/Engine/Types/Scenario.hs` – סוג הנתונים `Scenario` עם השדות:
  - `scenarioInfo` (מזהה, שם, תיאור, שלבים)
  - `scenarioInitialState` (מצב התחלתי)
  - `scenarioTransitions` (מעברים אופציונליים ב־Haskell)
  - `scenarioFinalState` (מצב סופי אופציונלי)
  - `scenarioParameters` (פרמטרים של הסימולציה)
  - `executeScenario` (פונקציה שמקבלת `EngineState` ומחזירה `IO (Either Text EngineState)`).

- `src/Engine/Scenarios/Library.hs` – רישום כל התרחישים הזמינים:
  ```hs
  allScenarios :: [Scenario]
  findScenario :: ScenarioId -> Maybe Scenario
  listScenarios :: [ScenarioInfo]
  ```
  הוספת תרחיש חדש:
  1. מגדירים ערך חדש מסוג `Scenario`.
  2. מוסיפים אותו ל־`allScenarios`.

- `src/Engine/Runner/BasicRunner.hs` – מנוע הריצה:
  - `formatStateIO` – המרת `EngineState` ל־`Text`, כולל קריאות FFI ל־Agda.
  - `runWithRealtimeOutput` – הלולאה שמריצה סימולציה בזמן אמת.

- `src/Engine/Runner/CliRunner.hs` – ממשק CLI:
  - `list` – מציג תרחישים (`run list`).
  - `run <ID>` – מריץ תרחיש ומציג מצב סופי.
  - `run-rt <ID>` – מריץ תרחיש בפלט בזמן אמת.
  - `info <ID>` – מציג פרטי תרחיש.
  - `sequence ID1 ID2 ...` – רץ רצף של תרחישים לפי סדר.

המודולריות המובנית הזו מאפשרת להוסיף ולתחזק תרחישים מבלי לפגוע בשכבות האחרות של המערכת.

# EtzChaim — ניהול שכבות ותרחישי סימולציה

EtzChaim היא מערכת סימולציית השתלשלות עולמות בשפת Agda, עם ממשק Haskell להרצה וניהול תרחישים.

---

## מבנה השכבות
1. **Domain / State** (קבצים ב־`src/Hishtalshelut/Domain/`)
   - הגדרת טיפוסי נתונים בלבד (State).
   - אין כאן חוקי הרצה או תצוגה.

2. **Rules** (קבצים ב־`src/Hishtalshelut/Rules/`)
   - חוקי בנייה וטרנספורמציות לפעולות על ה־State.
   - אין כאן הרצת Trace מלאה.

3. **Engine** (קבצים ב־`src/Hishtalshelut/Engine/`)
   - מנוע הסימולציה שמריץ את ה־Trace המלא.
   - מפעיל את הפונקציות מ־Rules, מייצר פלט טקסטואלי.

4. **Runtime / Scenario (Agda)** (קבצים ב־`src/Hishtalshelut/Runtime/Worlds/`)
   - תרחישי Agda להגדרת סצנות הפעלה.
   - מביאים את הפלט מ־Engine ומדפיסים אותו.

5. **Haskell Interface & Scenario Library** (קבצים ב־`src/Engine/`)
   - ממשק CLI להרצת תרחישי סימולציה.
   - ספריית תרחישים (`Library.hs`) וסוג הנתונים `Scenario`.
   - מנוע הריצה ב־`BasicRunner.hs` ו־`CliRunner.hs`.

---

## ספריית תרחישים (src/Engine/Scenarios/Library.hs)
- **allScenarios :: [Scenario]** — כל התרחישים הזמינים.
- **findScenario :: ScenarioId → Maybe Scenario** — חיפוש לפי מזהה.
- **listScenarios :: [ScenarioInfo]** — מידע על כל התרחישים.

**הוספת תרחיש חדש**:
1. ב־`Library.hs` מגדירים ערך חדש מסוג `Scenario`.
2. מוסיפים אותו לרשימת `allScenarios`.

---

## סוג הנתונים Scenario (src/Engine/Types/Scenario.hs)
```hs
data Scenario = Scenario
  { scenarioInfo         :: ScenarioInfo      -- מזהה, שם, תיאור, שלבים
  , scenarioInitialState :: EngineState       -- State התחלתי
  , scenarioTransitions  :: [Transition]      -- (אופציונלי) מעברים ב־Haskell
  , scenarioFinalState   :: Maybe EngineState -- מצב סופי אופציונלי
  , scenarioParameters   :: SimulationParameters
  , executeScenario      :: EngineState → IO (Either Text EngineState)
  }
```

---

## מנוע הריצה (Runner)
### BasicRunner (src/Engine/Runner/BasicRunner.hs)
- **formatStateIO**: המרת `EngineState` ל־`Text`, כולל קריאות FFI ל־Agda.
- **runWithRealtimeOutput**: לולאה שמריצה סימולציה בזמן אמת ומדפיסה בכל שלב.

### CliRunner (src/Engine/Runner/CliRunner.hs)
ממשק שורת הפקודה (`runCli`) תומך ב:
- `list`        — הצגת רשימת תרחישים.
- `run <ID>`    — הרצת תרחיש ודיווח על המצב הסופי.
- `run-rt <ID>` — הרצת תרחיש בפלט בזמן אמת.
- `info <ID>`   — מידע על תרחיש ספציפי.
- `sequence ID1 ID2 ...` — הרצת רצף תרחישים לפי סדר.
- `help`        — תיעוד פקודות.

**דוגמה לשימוש**:
```bash
etz-sim list
etz-sim run tzimtzum-full
etz-sim run-rt einsof-scenario
etz-sim sequence einsof-scenario tzimtzum-full
``` 

---

## הנחיות עיצוב ושימור מודולריות
- **Domain / Rules / Engine / Runtime**: אין לשלב ביניהם. כל לוגיקה נשמרת בשכבה המתאימה.
- **הוספת תרחישים**: רק ב־`Library.hs` וב־`Types/Scenario.hs`.
- **התאמות IO והדפסות**: במודול `Runner` בלבד.
- **שינויים בלוגיקה**: רק ב־Rules עבור טרנספורמציות.
- **שמירה על עקביות**: הוספה או עדכון תרחיש לא ישפיעו על השכבות האחרות.

---

## בנייה והרצה
```bash
# קומפילציה של Agda
make check
# בניית Haskell
cabal update && cabal build
# הרצת CLI
cabal run etz-sim -- run tzimtzum-full
cabal run etz-sim -- list
```

---

בהצלחה בתחזוקת המערכת ובהרחבת התרחישים!
