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
```

### פרצופים
```agda
-- InternalZONPresence.agda
 data InternalZONPresence : Set where
   NoInternalZON  : InternalZONPresence
   HasInternalZON : InternalZONPresence
```

### כללי
```agda
-- Orientation.agda
 data Side : Set where
   RightSide : Side
   LeftSide  : Side
   Center    : Side

 data Orientation : Set where
   Up     : Orientation
   Down   : Orientation
   Front  : Orientation
   Back   : Orientation

-- HeadMiddleEnd.agda
 data HeadMiddleEnd : Set where
   Head   : HeadMiddleEnd
   Middle : HeadMiddleEnd
   End    : HeadMiddleEnd
```

## קווים מנחים להרחבה
- כל טיפוס חדש יש להוסיף במודול ייעודי.
- יש להימנע מהגדרת טיפוסים כפולים בשכבות שונות.
- יש לעדכן את All.agda בכל הוספה של טיפוס מרכזי חדש.

---

*לשאלות, הרחבות או בקשות דוקומנטציה נוספת – ניתן לפנות למתחזקי המערכת.*
