# Hishtalshelut Domain Layer – Documentation

מערכת זו מייצגת את המבנה הקבלי של עולם ההשתלשלות (Hishtalshelut) באמצעות טיפוסים, מבנים ומודולים בשפת Agda. המטרה היא ליצור מודל פורמלי, מודולרי ובר-תחזוקה של המושגים המרכזיים בקבלה, תוך שמירה על סדר היררכי ברור בין שכבות המערכת.

## עקרונות עיצוב
- **מודולריות**: כל מושג קבלי מיוצג במודול עצמאי, תחת חלוקה הגיונית (אור, כלים, עולמות, פרצופים, כללי וכו').
- **הפרדה בין שכבות**: אין ערבוב בין מושגים השייכים לשכבות שונות (למשל, טיפוסי אור לא נמצאים בשכבת הכלים ולהפך).
- **הסתרת כפילויות**: טיפוסים ייחודיים מוגדרים רק במקום אחד ומיובאים לכל מקום נדרש.
- **ייבוא מרכזי**: קובץ All.agda מרכז את כל הייבוא של הטיפוסים המרכזיים למודול אחד, לנוחות שימוש ותחזוקה.

## מבנה ספריה
- `Domain/Light/` – טיפוסי אור: רמות, סוגי אור (פנימי/מקיף), ניצוץ, שפע וכו'.
- `Domain/Kelim/` – טיפוסי כלים: סוגי כלים, חומרים, קיבולת.
- `Domain/Sefirah/` – טיפוסי ספירות: שמות הספירות, מבנה, שמות אלוקיים.
- `Domain/Worlds/` – עולמות: אין-סוף, חלל, קו, עיגולים, אדם קדמון, אצילות, בריאה, יצירה, עשיה.
- `Domain/Partzuf/` – פרצופים: שמות, שלבים, פנים/אחור, ראש-תוך-סוף.
- `Domain/General/` – טיפוסים כלליים: צדדים (ימין/שמאל/אמצע), כיוונים (מעלה/מטה/פנים/אחור), ראש-תוך-סוף, עזרים.
- `Domain/Zivug/` – טיפוסי זיווג: שפע, מים נוקבין.

## דוגמאות טיפוסים מרכזיים

### אור
```agda
-- OhrPnimiMakif.agda
 data OhrPnimiMakif : Set where
   OhrPnimi : OhrPnimiMakif
   OhrMakif : OhrPnimiMakif
```

### כלים
```agda
-- KeliSubstance.agda
 data KeliSubstance : Set where
   Zahav   : KeliSubstance -- זהב
   Kesef   : KeliSubstance -- כסף
   Nechoshet: KeliSubstance -- נחושת
```

### עולמות
```agda
-- Challal.agda
 data Challal : Set where
   EmptySpace  : Challal
   FilledSpace : Challal

-- Igul.agda
 data Igul : Set where
   IgulLevel : ℕ → Igul

**EinSof (אין-סוף)** [`src/Hishtalshelut/Domain/Worlds/EinSof.agda`]
```agda
record EinSof : Set where
  constructor einsOf
```
תיאור: טיפוס יחידה המייצג את מהות אור אין-סוף – אחיד, פשוט וללא הבחנה פנימית בין מופעים.

**EinSofProperties**  
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
תיאור: אוסף שדות לתיאור תכונות EinSof:
- `indistinguishable`: תמיד True – אין הבחנה פנימית בין מופעים.
- `hasBoundary`: False – אין גבול.
- `isUniform`: True – אחידות מוחלטת.
- `mapInvariant`: בודק שכל פונקציה על EinSof מחזירה אותו עצמו.
- `location`, `direction`, `receiveFromEinSof`: שדות סטטיים המייצגים תכונות קבועות (יחידה).
- `description`: תיאור מילולי לשימוש בתיעוד.

**Wrappers** [`CircleEinSof`, `KavEinSof`]  
```agda
record CircleEinSof : Set where
  constructor circleOf
  field underlying : EinSof

record KavEinSof : Set where
  constructor kavOf
  field underlying : EinSof
```
תיאור: עטיפות EinSof להקשרים גאומטריים:
- `CircleEinSof`: עבור ייצוג EinSof בתוך עיגול.
- `KavEinSof`: עבור ייצוג EinSof בתוך קו.


## קווים מנחים להרחבה
- כל טיפוס חדש יש להוסיף במודול ייעודי.
- יש להימנע מהגדרת טיפוסים כפולים בשכבות שונות.
- יש לעדכן את All.agda בכל הוספה של טיפוס מרכזי חדש.

---

*לשאלות, הרחבות או בקשות דוקומנטציה נוספת – ניתן לפנות למתחזקי המערכת.*
