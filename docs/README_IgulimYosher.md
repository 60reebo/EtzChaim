# סימולציית IgulimYosher

## 1. סקירה כללית
סימולציית IgulimYosher מדמה את תהליך יצירת עולמות עגולים (Igulim) ותיקונם (Yosher) לפי חוקי רש"ש:
- יצירת העיגולים הראשוניים (Circles)
- צמצום וצינון (Contraction)
- תיקון גיאומטרי (Geometry)

פקודות הרצה:
```bash
cabal run etzchaim -- עגולים        # Igulim בלבד
cabal run etzchaim -- צמצום 3      # Contraction בעומק 3
cabal run etzchaim -- גיאומטריה    # Geometry trace
cabal run etzchaim -- הכל          # כל השלבים ברצף
```

---

## 2. מבנה השכבות

### Domain (שכבת דומיין)
**קובץ**: `src/Hishtalshelut/Domain/Worlds/IgulimYosher.agda`

#### OlamId (מזהה עולם)
```agda
record OlamId : Set where
  field
    name  : String
    level : ℕ
```
תיאור: שם ומדרג לכל עולם בסדר ההשתלשלות.

#### PartzufId (מזהה פרצוף)
```agda
record PartzufId : Set where
  field
    name  : String
    olam  : OlamId
    level : ℕ
```
תיאור: מזהה פרצוף בתוך עולם.

#### SefirahId (מזהה ספירה)
```agda
record SefirahId : Set where
  field
    name  : String
    index : ℕ
```
תיאור: שם ואינדקס לכל ספירה.

#### LightCategory (קטגוריית אור)
```agda
data LightCategory : Set where
  Nefesh  : LightCategory
  Ruach   : LightCategory
  Neshama : LightCategory
  Chaya   : LightCategory
  Yechida : LightCategory
```
תיאור: דרגות אור לפי נרנ"ח"י.

#### KavState (מצב קו)
```agda
record KavState : Set where
  field
    headAttached : Bool
    tailAttached : Bool
    einsofValue  : EinSof
```
תיאור: חיבור הקו לאין־סוף ולעיגולים.

#### CircleDesc (תיאור עיגול)
```agda
record CircleDesc : Set where
  field
    olam    : OlamId
    partzuf : PartzufId
    sefirah : SefirahId
    isMakif : Bool
    lightCat: LightCategory
    purity  : ℕ
```
תיאור: פרמטרים ליצירת עיגולים חיצוניים ופנימיים.

#### YosherDesc (תיאור יושר)
```agda
record YosherDesc : Set where
  field
    olam     : OlamId
    partzuf  : PartzufId
    isPnimi  : Bool
    isMakif  : Bool
    covers   : List CircleDesc
    distance : ℕ
    lightCat : LightCategory
    purity   : ℕ
```
תיאור: תיאור מצבי יושר פנימיים והיקפיים.

#### CircleSpec / YosherSpec / SefirahUnit
```agda
record CircleSpec : Set where ...
record YosherSpec : Set where ...
record SefirahUnit : Set where
  field
    circle : CircleSpec
    yosher : YosherSpec
```
תיאור: מפרט מלא לכל מבנה יחיד.

#### Light (זרם אור)
```agda
record Light : Set where
  field
    einsofCtx : CircleEinSof ⊎ KavEinSof
    category  : LightCategory
    active    : Bool
    intensity : ℕ
    purity    : ℕ
```
תיאור: מצב אור לאחר העברה עם כל המאפיינים.

#### פונקציות עזר
```agda
transmitLight : KavState → (CircleDesc ⊎ YosherDesc) → Light
internalStream : CircleDesc → KavState → Light
externalStream : YosherDesc → KavState → Light
```
תיאור: מיפוי פרמטרים לזרם אור פנימי/חיצוני.

#### פונקציות נוספות ב-Domain
- `worldToId` : World → OlamId
- `partzufToId` : World → Partzuf → PartzufId
- `sefirahToId` : Sefirah → SefirahId
- `sefirahTriad`, `sefirahHexad`, `sefirahNarnah` : מיפוי Sefirah ל-Triad/Hexad/Narnah
- `sefirahUnit` : Sefirah → SefirahUnit
- `sefirahUnitById` : SefirahId → SefirahUnit
- `baseRadius`, `growthFactor`, `radius`, `circumference`, `area`, `volume` : פונקציות גיאומטריות
- `listLookup` : ℕ → List A → Maybe A
- `sefirahById` : SefirahId → Sefirah

### State (שכבת מצב)
**קובץ**: `src/Hishtalshelut/State/Worlds/IgulimYosherFullState.agda`

#### IgulimYosherFullState
```agda
record IgulimYosherFullState : Set where
  field
    reshimuState       : ReshimuState
    compositeByPartzuf : List (OlamId × PartzufId × SefirahUnit)
    kavState           : KavState
    contractionState   : ContractionState
```
תיאור: מצב כולל עיגולים, יושר, קו וצמצום.

#### initialIgulimYosherFullState
```agda
initialIgulimYosherFullState : IgulimYosherFullState
initialIgulimYosherFullState = record
  { reshimuState       = initialReshimuState
  ; compositeByPartzuf = []
  ; kavState           = record { headAttached = true; tailAttached = false; einsofValue = einsOf }
  ; contractionState   = initialContractionState initialEinSofState
  }
```
תיאור: מצב התחלתי ריק.

#### פונקציות סטייט ב-IgulimYosherFullState
- `initialIgulimYosherFullState` : IgulimYosherFullState
- `circlesByPartzuf` : IgulimYosherFullState → List (OlamId × List CircleDesc)
- `yosherByPartzuf` : IgulimYosherFullState → List (OlamId × List YosherDesc)

### Rules (שכבת חוקים)
**קובץ**: `src/Hishtalshelut/Rules/Worlds/IgulimYosherRules.agda`

#### buildHierarchicalUnits
```agda
buildHierarchicalUnits : List (OlamId × PartzufId × SefirahUnit)
```
תיאור: בניית רשימת כל היחידות לפי עולמות ופרצופים.

#### buildYosherSteps
```agda
buildYosherSteps : OlamId → PartzufId → List HierarchicalStepLocal
```
תיאור: בניית שלבי יושר פנימי והיקפי.

#### buildContractionSteps
```agda
buildContractionSteps : ℕ → List HierarchicalStepLocal
```
תיאור: שלבי צמצום (`TzimtzumCenter`, `ContractStep`, `RecordContractionReshimu`).

#### stepHierarchical
```agda
stepHierarchical : HierarchicalStepLocal → IgulimYosherFullState → IgulimYosherFullState
```
תיאור: יישום כל שלב על המצב הנוכחי.

#### פונקציות Rules זמינות
- `buildHierarchicalUnits` : List (OlamId × PartzufId × SefirahUnit)
- `buildYosherSteps` : OlamId → PartzufId → List HierarchicalStepLocal
- `buildContractionSteps` : ℕ → List HierarchicalStepLocal
- `hierarchicalExpansionSteps` : List HierarchicalStepLocal
- `simulateHierarchicalTrace` : List IgulimYosherFullState
- `goHierarchicalTrace` : List HierarchicalStepLocal → IgulimYosherFullState → List IgulimYosherFullState
- `fillChallalWithIgulimYosher` : IgulimYosherFullState

### Engine Entry (שכבת מנוע)
**קבצים**:
- `MAlonzo.Code.Hishtalshelut.Engine.Worlds.IgulimYosherEngine` (hierarchical)
- `MAlonzo.Code.Hishtalshelut.Engine.Worlds.TzimtzumEngine` (contraction)
- `MAlonzo.Code.Hishtalshelut.Engine.Geometry3D`       (geometry)

```haskell
d_hierarchicalTraceText_248 :: [String]
d_contractionTraceText_250 :: Integer → [String]
d_geometryTraceText_456   :: [String]
```
תיאור: נקודות כניסה להפקת Trace טקסטואלי לכל שלב בסימולציה.

### Runtime / CLI (שכבת ריצה)
**קובץ**: `src/Hishtalshelut/Runtime/Simulation.hs`

תת־פקודות ופעולה:
```bash
"עגולים"    -> d_hierarchicalTraceText_248
"צמצום" n  -> d_contractionTraceText_250 n
"גיאומטריה" -> d_geometryTraceText_456
"הכל"      -> combine כל השלבים
```

---

## 3. השלבים הבאים
- להריץ ולבדוק פלט טקסטואלי לכל תרחיש.
- להוסיף בדיקות יחידה ו־golden tests לאימות יציבות הפלט.
- לדייק ניסוחים ולבצע התאמות בהתאם.

## גישת מקור אמת יחיד לטקסט הסימולציה

במטרה להבטיח שכל הטקסט התיאורי (כותרות ושלבי הסימולציה) יופק ישירות מתוך הקוד (Agda/Engine), נקבע את מקור האמת הבא:
- ב-Agda: `stepToHebrew : ContractionStep → String`, `contractionHeader : List String` ו-`contractionTraceText : List String` בקובץ `TzimtzumEngine.agda`.
- ייצוא ל-Haskell כ-`d_contractionTraceText : Integer → [String]` במודול `MAlonzo.Code.Hishtalshelut.Engine.Worlds.TzimtzumEngine`.
- ב-Haskell: `simulateContractionDetailed` ו-`simulateContractionFlow` קוראים ל-`d_contractionTraceText`.
- CLI: תת־פקודה `"צמצום-דינמי"` מפנה ל-`simulateContractionFlow`.
- CI: סקריפט מריץ `cabal run etzchaim -- צמצום-דינמי 3 > docs/contraction_example.md`.

### תוכנית עבודה למימוש

1. (Agda) הוספת `stepToHebrew`, `contractionHeader` ועדכון `contractionTraceText` ב-`src/Hishtalshelut/Engine/Worlds/TzimtzumEngine.agda`.
2. קומפילציה עם `agda2hs` ובדיקה ש-`d_contractionTraceText` מיוצאת במודול המיוצא.
3. (Haskell) ב-`src/Hishtalshelut/Runtime/Simulation.hs`: הוספת `simulateContractionDetailed` ושימוש בו ב-`simulateContractionFlow`.
4. הרצת `cabal build` ובדיקת פלט באמצעות `cabal run etzchaim -- צמצום-דינמי 3`.
5. (Docs) הוספת קטע `Example:` ב-README עם פלט הריצה באותו הקובץ.
6. (CI) הוספת משימה בהרצת `cabal run etzchaim -- צמצום-דינמי 3 > docs/contraction_example.md`.

#### Example
```bash
$ cabal run etzchaim -- צמצום-דינמי 3
=== Stage 0: מצב טרום-אתחול (אין סוף) ===
EinSofState { einSof = einsOf, isFullOfLight = true }
ContractionState { radius = 0, reshimu = NoReshimu, status = NoTzimtzum, hasLight = true }

=== Stage 1: אירוע מחולל וצמצום ===
מפעיל אירוע: רצון_אלוהי_לברוא.
מבצע פונקציה ראשית: צמצום.

Step 1/3: void→1
  before: { radius = 0, reshimu = NoReshimu }
  action : ContractStep 1
  after  : { radius = 1, reshimu = NoReshimu }

Step 2/3: void→2
  before: { radius = 1, reshimu = NoReshimu }
  action : ContractStep 2
  after  : { radius = 2, reshimu = NoReshimu }

Step 3/3: void→3
  before: { radius = 2, reshimu = NoReshimu }
  action : ContractStep 3
  after  : { radius = 3, reshimu = NoReshimu }
