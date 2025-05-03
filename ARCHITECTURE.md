# ארכיטקטורת EtzChaim - מבנה המערכת ומודלים

מסמך זה מתאר את הארכיטקטורה הכוללת של סימולטור EtzChaim, שכבות המערכת והיחסים ביניהן.

## תוכן עניינים
1. [שכבות המערכת](#שכבות-המערכת)
2. [דיאגרמת מבנה](#דיאגרמת-מבנה)
3. [זרימת מידע בסימולציה](#זרימת-מידע-בסימולציה)
4. [טיפוסים מרכזיים](#טיפוסים-מרכזיים)
5. [אינטגרציה בין שכבות](#אינטגרציה-בין-שכבות)

---

## שכבות המערכת

מערכת EtzChaim בנויה במבנה מרובד ברור:

### 1. שכבת הדומיין (Domain Layer)
שכבה זו מכילה את ההגדרות המתמטיות והקבליות הטהורות:
- טיפוסים מתמטיים (אורדינלים, קרדינלים)
- טיפוסים קבליים (אור, כלי, רשימו)
- מבנים בסיסיים (עולמות, פרצופים, ספירות)

קבצים מרכזיים:
- `Hishtalshelut/Domain/Math/Ordinal.agda`
- `Hishtalshelut/Domain/Math/Cardinal.agda`
- `Hishtalshelut/Domain/CoreTypes/Light.agda`
- `Hishtalshelut/Domain/CoreTypes/Keli.agda`
- `Hishtalshelut/Domain/Worlds/IgulimYosher.agda`

### 2. שכבת המצב (State Layer)
שכבה זו מכילה מופעים קונקרטיים של הטיפוסים המוגדרים בשכבת הדומיין:
- מופעי עולמות
- מופעי כלים ואורות
- מצבים התחלתיים ומצבי ביניים

קבצים מרכזיים:
- `Hishtalshelut/State/Worlds/IgulimYosherFullState.agda`
- `Hishtalshelut/State/Worlds/TzimtzumState.agda`
- `Hishtalshelut/State/Instance/*.agda`

### 3. שכבת החוקים (Rules Layer)
שכבה זו מגדירה את החוקים והלוגיקה שמפעילים את המערכת:
- חוקי התפשטות האור
- חוקי אינטראקציה בין אור לכלים
- חוקי השתלשלות העולמות

קבצים מרכזיים:
- `Hishtalshelut/Rules/Light/LightTransformations.agda`
- `Hishtalshelut/Rules/Worlds/IgulimYosherRules.agda`

### 4. שכבת המנוע (Engine Layer)
שכבה זו אחראית על ההרצה בפועל של הסימולציה:
- אינטגרציה של כל השכבות
- הרצת שלבים היררכיים
- ויזואליזציה וייצוא של התוצאות

קבצים מרכזיים:
- `Hishtalshelut/Engine/Worlds/IgulimYosherEngine.agda`
- `Hishtalshelut/Engine/Worlds/EinSofEngine.agda`
- `Hishtalshelut/Engine/Geometry3D.agda`

---

## דיאגרמת מבנה

```
┌─────────────────────────────────────────────────────┐
│                    Engine Layer                     │
│  ┌─────────────────┐  ┌───────────────────────┐    │
│  │  EinSofEngine   │  │   IgulimYosherEngine  │    │
│  └─────────────────┘  └───────────────────────┘    │
└───────────────────────────┬─────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────┐
│                     Rules Layer                     │
│  ┌─────────────────┐  ┌───────────────────────┐    │
│  │LightTransform-  │  │  IgulimYosherRules    │    │
│  │ations           │  │                       │    │
│  └─────────────────┘  └───────────────────────┘    │
└───────────────────────────┬─────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────┐
│                     State Layer                     │
│  ┌─────────────────┐  ┌───────────────────────┐    │
│  │FullState        │  │  TzimtzumState        │    │
│  │                 │  │                       │    │
│  └─────────────────┘  └───────────────────────┘    │
└───────────────────────────┬─────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────┐
│                    Domain Layer                     │
│  ┌─────────┐  ┌─────────┐  ┌────────┐  ┌────────┐  │
│  │Ordinal  │  │Cardinal │  │Light   │  │Keli    │  │
│  └─────────┘  └─────────┘  └────────┘  └────────┘  │
│                                                     │
│  ┌─────────────────┐  ┌───────────────────────┐    │
│  │IgulimYosher     │  │  LightChain           │    │
│  │                 │  │                       │    │
│  └─────────────────┘  └───────────────────────┘    │
└─────────────────────────────────────────────────────┘
```

---

## זרימת מידע בסימולציה

תהליך הסימולציה עובר את השלבים הבאים:

1. **אתחול** - יצירת המצב ההתחלתי:
   - טעינת מצב האין-סוף הראשוני
   - הגדרת פרמטרים התחלתיים

2. **צמצום וחלל פנוי**:
   - יצירת החלל הפנוי המרכזי
   - השארת רשימו

3. **המשכת קו האור**:
   - התפשטות האור מהאין-סוף לתוך החלל הפנוי
   - יצירת קו האור הראשוני

4. **בניית עולמות**:
   - יצירת עיגולים לכל עולם
   - יצירת יושר לכל עולם

5. **בניית פרצופים**:
   - יצירת המבנה הפנימי של כל עולם
   - הקצאת כלים לספירות בפרצופים

6. **זרימת אור**:
   - העברת אור דרך הכלים
   - אינטראקציות בין אורות וכלים

7. **ויזואליזציה**:
   - המרת המצבים למודל 3D
   - הצגה ויזואלית של התהליך

זרימת המידע מתרחשת בצורה הבאה:
```
[Domain Definitions] → [Initial State] → [Apply Rules] → [Engine Processing] → [Visualization]
```

---

## טיפוסים מרכזיים

### אורדינלים וקרדינלים
```agda
data Ordinal (ℓ : Level) : Set ℓ where
  zero  : Ordinal ℓ
  succ  : Ordinal ℓ → Ordinal ℓ
  limit : (ℕ → Ordinal ℓ) → Ordinal ℓ

data Cardinal (ℓ : Level) : Set ℓ where
  fin   : ℕ → Cardinal ℓ
  aleph : Ordinal ℓ → Cardinal ℓ
```

### אור
```agda
record Light : Set (lsuc ℓ) where
  constructor mkLight
  field
    power     : Cardinal ℓ     -- עוצמת האור
    structure : Ordinal ℓ      -- מבנה/סדר האור
    category  : LightCategory  -- קטגוריית האור
    kind      : LightKind      -- סוג האור
    source    : String         -- מקור האור
    timestamp : Ordinal ℓ      -- חותמת זמן
```

### כלי
```agda
record Keli : Set (lsuc ℓ) where
  constructor mkKeli
  field
    seph      : Sefirah        -- ספירה
    kind      : VesselKind     -- סוג הכלי
    substance : KeliSubstance  -- חומר הכלי
    capacity  : Cardinal ℓ     -- קיבולת
    content   : Light          -- תוכן
    label     : Maybe String   -- תווית
```

### מצב מלא
```agda
record IgulimYosherFullState : Set where
  field
    reshimuState     : ReshimuState
    compositeByPartzuf : PartzufIdMap (List CircleDesc)
    kavState         : KavState
    contractionState : ContractionState
    ordinalLevels    : List (OlamId × PartzufId × Ordinal lzero)
    cardinalLevels   : List (OlamId × PartzufId × Cardinal lzero)
    keliState        : List (OlamId × PartzufId × List Keli)
```

---

## אינטגרציה בין שכבות

### מדומיין למצב
המעבר מהדומיין למצב מתבצע דרך יצירת מופעים:
```agda
initialIgulimYosherFullState : IgulimYosherFullState
```

### ממצב לחוקים
החוקים מופעלים על המצב הנוכחי:
```agda
stepHierarchical : HierarchicalStepLocal → IgulimYosherFullState → IgulimYosherFullState
```

### מחוקים למנוע
המנוע מרכיב את החוקים לתרחיש סימולציה מלא:
```agda
simulateHierarchicalTrace : List IgulimYosherFullState
```

### ממנוע לויזואליזציה
המנוע ממיר את תוצאות הסימולציה למודל ויזואלי:
```agda
toGeometryStep : HierarchicalStepLocal → GeometryStep
```

---

לשאלות נוספות או הרחבות על ארכיטקטורת המערכת, נא לפנות למפתחים או לעיין בקוד המקור המתועד. 