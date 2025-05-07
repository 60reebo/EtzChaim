# סימולציית Tzimtzum — הצמצום

## 1. סקירה כללית
סימולציית Tzimtzum מדמה את תהליך הצמצום (Tzimtzum):
- מעבר מאור אינסוף לריקנות
- מעקב אחר Reshimu (הטביעת רישימו)

**פקודות הרצה:**
```bash
cabal run etzchaim -- צמצום           # ברירת מחדל depth=3
cabal run etzchaim -- צמצום --depth 5  # עומק צמצום = 5
cabal run etzchaim -- צמצום-דינמי 3  # הרצת צמצום דינמי עם לוג חי
```

---

## 2. מבנה השכבות

<details><summary>Domain</summary>

### Domain Types

#### EinSof (אין-סוף)
**קובץ**: `src/Hishtalshelut/Domain/Worlds/EinSof.agda`
```agda
record EinSof : Set where
  constructor einsOf
```
תיאור: ייצוג של אור אין־סוף כטיפוס יחידה – מקור אחיד, פשוט ואינסופי של אור שאין בו הבחנה פנימית.

#### EinSofProperties
**קובץ**: `src/Hishtalshelut/Domain/Worlds/EinSof.agda`
```agda
record EinSofProperties : Set where
  field
    indistinguishable  : EinSof → EinSof → Bool
    hasBoundary       : Bool
    isUniform         : Bool
    mapInvariant      : (EinSof → EinSof) → EinSof → Bool
    location          : ⊤
    direction         : ⊤
    receiveFromEinSof : EinSof → ⊤
    description       : String
```
תיאור:
- `indistinguishable`: תמיד True, משקף כי אין הבחנה בין מופעים.
- `hasBoundary`: False, אין גבול לאור אינסופי.
- `isUniform`: True, האור אחיד לחלוטין.
- `mapInvariant`: פונקציה על EinSof מחזירה את אותו EinSof.
- `location`, `direction`, `receiveFromEinSof`: שדות יחידה המציינים שאין מיקום או כיוון משמעותיים.
- `description`: טקסט לשימוש בתיעוד המודל.

#### CircleEinSof (עיגול מן אין־סוף)
**קובץ**: `src/Hishtalshelut/Domain/Worlds/EinSof.agda`
```agda
record CircleEinSof : Set where
  constructor circleOf
  field underlying : EinSof
```
תיאור: עטיפה המציגה את EinSof בתוך הקשר מעגלי, מסמלת פיזור אור מעגלי מסביב לנקודה מרכזית.

#### KavEinSof (קו מן אין־סוף)
**קובץ**: `src/Hishtalshelut/Domain/Worlds/EinSof.agda`
```agda
record KavEinSof : Set where
  constructor kavOf
  field underlying : EinSof
```
תיאור: עטיפה המציגה את EinSof בקו ישר (Kav), מסמלת קרן אור ישירה היוצאת ממקור האינסוף.

#### TzimtzumSpec (מפרט הצמצום)
**קובץ**: `src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`
```agda
record TzimtzumSpec : Set where
  field
    center    : CenterPoint  -- נקודת ההתחלה של ההיצרות
    maxRadius : ℕ            -- רדיוס מגבלת הנסיגה
```
תיאור:
- `center`: נקודת המרכז שממנה מתבצעת ההיצרות (Midpoint).
- `maxRadius`: הגבולת הרדיוס המרבי של נסיגת האור לאזור ריק.

#### TzimtzumStatus (סטטוס הצמצום)
**קובץ**: `src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`
```agda
data TzimtzumStatus : Set where
  NoTzimtzum    : TzimtzumStatus
  AfterTzimtzum : TzimtzumStatus
```
תיאור:
- `NoTzimtzum`: לפני ביצוע ההיצרות – האור עדיין אינסופי ומלא עוצמה.
- `AfterTzimtzum`: לאחר ביצוע ההיצרות – האור חלקי, נשאר רישימו של המרחב.

#### WillForCreation (רצון לבריאה)
**קובץ**: `src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`
```agda
data WillForCreation : Set where
  NoWill        : WillForCreation
  PotentialWill : WillForCreation
```
תיאור:
- `NoWill`: לא קיים רצון ליצירה.
- `PotentialWill`: הופיע רצון פוטנציאלי, טריגר להזנקת תהליך הבריאה.

#### ReshimuLevel (רישימו)
**קובץ**: `src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`
```agda
data ReshimuLevel : Set where
  NoReshimu   : ReshimuLevel
  WithReshimu : ReshimuLevel
```
תיאור:
- `NoReshimu`: לא נוצרה טביעת זיכרון של האור במרחב.
- `WithReshimu`: נוצרת רישימו, משמרת עקבות של אור אין־סוף.

#### ContractionStep (שלבי הצמצום)
**קובץ**: `src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`
```agda
data ContractionStep : Set where
  StepStartEinSof     : ContractionStep  -- התחלת האור האינסופי
  StepPotentialWill   : ContractionStep  -- הופעת הרצון כמתווך
  StepExecuteTzimtzum : ContractionStep  -- ביצוע ההיצרות בפועל
  StepLeaveReshimu    : ContractionStep  -- הטבעת הרישימו במרחב
```
תיאור: ארבעת השלבים בסימולציה, כל אחד משיקוף של שלב לוגי בפירוק ובספיגת האור.

#### CenterPoint (נקודת מרכז)
**קובץ**: `src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`
```agda
data CenterPoint : Set where
  Midpoint : CenterPoint  -- נקודת אמצע המדויקת של ההיצרות
```
תיאור: نقطة بודדת המייצגת את מרכז ההיצרות.

#### CircleShape (צורת עיגול)
**קובץ**: `src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`
```agda
record CircleShape : Set where
  field
    center : CenterPoint  -- נקודת המרכז
    radius : ℕ            -- הרדיוס הנוכחי של אזור ההיצרות
```
תיאור: מייצג את הגבול המעגלי של ריכוז האור המתכווץ.

</details>

<details><summary>State</summary>

### EinSofState (מצב אין-סוף)
**קובץ**: `src/Hishtalshelut/State/Worlds/EinSofState.agda`
```agda
record EinSofState : Set where
  field
    einSof        : EinSof     -- מופע של EinSof (מקור האור)
    isFullOfLight : Bool       -- האם האזור מלא אור (True) או לא (False)
```
תיאור:
- `einSof`: מופע של EinSof, מייצג מקור האור האינסופי.
- `isFullOfLight`: True כאשר כל המרחב מלא באור, False כאשר התחילה ריקנות.

### ContractionState
**קובץ**: `src/Hishtalshelut/State/Worlds/TzimtzumState.agda`
```agda
record ContractionState : Set where
  field
    einSofState : EinSofState    -- מצב גאומטרי של EinSof (עיגול, קו וכו')
    will        : WillForCreation -- האם הופיע רצון לבריאה (NoWill / PotentialWill)
    status      : TzimtzumStatus  -- סטטוס ההיצרות (לפני/אחרי Tzimtzum)
    hasLight    : Bool            -- האם נותר אור פעיל לאחר השלב
    reshimu     : ReshimuLevel    -- רמת הרישימו (NoReshimu / WithReshimu)
    radius      : ℕ               -- הרדיוס הנוכחי של אזור ההיצרות
    spec        : TzimtzumSpec    -- מפרט גאומטרי של תהליך ההיצרות
```
תיאור שדות:
- `einSofState`: מגדיר את המבנה הגאומטרי והמצב הנוכחי של אור אין־סוף.
- `will`: מציין אם הרצון לבריאה הופיע כטריגר להתחלת התהליך.
- `status`: עוקב אחרי אם התהליך לפני הצמצום (`NoTzimtzum`) או לאחריו (`AfterTzimtzum`).
- `hasLight`: בוליאני המציין אם נשאר אור פעיל באזור הריק לאחר ביצוע השלב.
- `reshimu`: מציין אם נוצרה טביעת זיכרון של האור במרחב.
- `radius`: גודל הנסיגה הנוכחי (מספר טבעי) של האור מהמרכז.
- `spec`: קובץ המפרט את נקודת המרכז והרדיוס המרבי לתהליך הצמצום.

</details>

<details><summary>Rules</summary>

### TzimtzumRules

#### startWithFullEinSof
**קובץ**: `src/Hishtalshelut/Rules/Worlds/Tzimtzum.agda`
```agda
startWithFullEinSof : ⊤ → ContractionState
```
תיאור:
- יוצרת את `initialContractionState` מתוך `initialEinSofState` כדי להתחיל בסימולציית הצמצום ממצב מלא אור.

#### potentialWillForCreation
**קובץ**: `src/Hishtalshelut/Rules/Worlds/Tzimtzum.agda`
```agda
potentialWillForCreation : ContractionState → ContractionState
```
תיאור:
- משנה את השדה `will` ל-`PotentialWill`, משקף הופעת רצון לבריאה.

#### executeTzimtzum
**קובץ**: `src/Hishtalshelut/Rules/Worlds/Tzimtzum.agda`
```agda
executeTzimtzum : ContractionState → ContractionState
```
תיאור:
- מעדכן את ה-`status` ל-`AfterTzimtzum`, מגדיר `hasLight = false` ומעלה את `radius` ב-1.

#### leaveReshimu
**קובץ**: `src/Hishtalshelut/Rules/Worlds/Tzimtzum.agda`
```agda
leaveReshimu : ContractionState → ContractionState
```
תיאור:
- מפעיל `afterContractionState` כדי לעדכן את ה-`reshimu` ל-`WithReshimu`.

#### buildContractionSteps
**קובץ**: `src/Hishtalshelut/Rules/Worlds/Tzimtzum.agda`
```agda
buildContractionSteps : ⊤ → List ContractionStep
buildContractionSteps _ = StepStartEinSof ∷ StepPotentialWill ∷ StepExecuteTzimtzum ∷ StepLeaveReshimu ∷ []
```
תיאור:
- בונה רשימה של כל השלבים הלוגיים (בפירוק וספיגת האור) בסדר הנכון לביצוע.

</details>

<details><summary>Engine</summary>

### Engine Entry

**d_contractionTraceText_250** [`MAlonzo.Code.Hishtalshelut.Engine.Worlds.IgulimYosherEngine`]
```haskell
d_contractionTraceText_250 :: Integer → [Text]
```
תיאור: מחזיר רשימת טקסט של שלבי הצמצום בעומק נתון.

</details>

<details><summary>Runtime / CLI</summary>

### Subcommand "צמצום"

**Simulation.hs** [`src/Hishtalshelut/Runtime/Simulation.hs`]
```haskell
-- תת-פקודה "צמצום" עם דגל `--depth`
```
תיאור: מאפשר לבחור עומק ולהציג פלט טקסטואלי של trace.

### Subcommand "צמצום-דינמי"

**Simulation.hs** [`src/Hishtalshelut/Runtime/Simulation.hs`]
```haskell
command "צמצום-דינמי"
  (info (DynamicContraction <$> argument auto (metavar "DEPTH"))
    (progDesc "Run dynamic contraction simulation with live logs"))
```
תיאור: 
- מריץ את `simulateContractionFlow depth`, המדפיס ב־CLI את כל שלבי הצמצום בעברית, כולל:
  1. `Stage 0`: מצב טרום־אתחול (EinSofState ו־ContractionState ראשוניים)
  2. `Stage 1`: אירוע מחולל וצמצום לוג בשפה העברית
  3. שלבי הצמצום המופקים מ־`d_contractionTraceText_250 depth`
- **דוגמה להרצה**:
```bash
$ cabal run etzchaim -- צמצום-דינמי 3
=== Stage 0: מצב טרום-אתחול (אין סוף) ===
EinSofState { … }
ContractionState { radius = 0, reshimu = NoReshimu }

=== Stage 1: אירוע מחולל וצמצום ===
מפעיל אירוע: רצון_אלוהי_לברוא.
מבצע פונקציה ראשית: צמצום.
Step 1/3: void→1
  before: { radius = 0, reshimu = NoReshimu }
  action : ContractStep 1
  after  : { radius = 1, reshimu = NoReshimu }
…
```
</details>

---

## 3. סיכום ואימות סופי

- **Domain**: כל טיפוסי ה-**Tzimtzum** מתועדים ומיושמים: `TzimtzumSpec`, `TzimtzumStatus`, `WillForCreation`, `ReshimuLevel`, `ContractionStep`, `CenterPoint`, `CircleShape`.
- **State**: `EinSofState`, `ContractionState` – תיאום מצבי התחלה (`initialEinSofState`, `initialContractionState`) וסיום (`afterContractionState`).
- **Rules**: `startWithFullEinSof`, `potentialWillForCreation`, `executeTzimtzum`, `leaveReshimu`, `buildContractionSteps`.
- **Engine**: `d_contractionTraceText_250` – מציג trace טקסטואלי בעומק ידני.
- **CLI**: תת־פקודה `"צמצום"` עם פלאג `--depth` – חיבור למנוע ההגדרות.

## 4. המשך

1. להתחיל בסימולציית Kav (קו).
2. תיעוד Kav בכל השכבות: Domain, State, Rules, Engine, CLI.
3. הגדרת תת־פקודה חדשה ב־CLI: `"קו"` עם פלאג `--depth`.
4. הוספת בדיקות יחידה ו־golden tests לסימולציית Kav.
