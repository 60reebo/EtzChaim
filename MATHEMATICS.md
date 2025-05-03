# אלגברה מתמטית ולוגיקה - פרויקט EtzChaim

מסמך זה מתאר את הפורמליזציה המתמטית והלוגיקה שבבסיס הסימולציה של אור ושפע בתהליך ההשתלשלות. אנו משתמשים בעקרונות מתמטיים מתורת הטיפוסים ההומוטופית (HoTT) לצד אלגברה קונסטרוקטיבית להגדרת ולעיבוד מדויק של תהליכי האור.

## תוכן העניינים

1. [מנגנון האורדינלים](#מנגנון-האורדינלים)
2. [מנגנון הקרדינלים](#מנגנון-הקרדינלים)
3. [אלגברת אורות](#אלגברת-אורות)
4. [מתמטיקת הכלים](#מתמטיקת-הכלים)
5. [יחסי גומלין אור-כלי](#יחסי-גומלין-אור-כלי)
6. [צמצום וטרנספורמציות](#צמצום-וטרנספורמציות)
7. [עקרונות פורמליים](#עקרונות-פורמליים)

## מנגנון האורדינלים

אורדינלים מייצגים סדר וגודל, ומשמשים לתיאור רמות מבנה האור והיררכיה.

```agda
data Ordinal (ℓ : Level) : Set ℓ where
  zero    : Ordinal ℓ
  succ    : Ordinal ℓ → Ordinal ℓ
  limit   : (ℕ → Ordinal ℓ) → Ordinal ℓ
```

### אורדינלים טרנספיניטיים

מערכת האורדינלים מאפשרת ייצוג של ערכים אינסופיים:

- `omega`: אורדינל אינסופי ראשון (ω)
- `omega²`: חזקת אומגה בשתיים (ω²)
- `Omega`: אורדינל גדול במיוחד (Ω)

### פעולות על אורדינלים

- חיבור: `_+_`: חיבור אורדינלי (לא קומוטטיבי)
- כפל: `_*_`: כפל אורדינלי (לא קומוטטיבי)
- חזקה: `_^_`: חזקה אורדינלית
- השוואה: `_≤_`: יחס סדר על אורדינלים

### תכונות מתמטיות מוכחות

- אסוציאטיביות של חיבור: `assoc⁺`
- אסוציאטיביות של כפל: `assoc*`
- פילוג של כפל על פני חיבור: `distrib*+`

## מנגנון הקרדינלים

קרדינלים מייצגים גדלים וכמויות, ומשמשים למדידת עוצמת אור:

```agda
data Cardinal (ℓ : Level) : Set ℓ where
  fin   : ℕ → Cardinal ℓ
  aleph : Ordinal ℓ → Cardinal ℓ
```

- `fin n`: מייצג מספר סופי בגודל n
- `aleph α`: מייצג את אלף-אלפא (אינסוף גדול לפי אורדינל α)

### קרדינלים מיוחדים

- `aleph0`: הקרדינל האינסופי הקטן ביותר (הכמות של המספרים הטבעיים)
- `aleph1`: העוקב של אלף-אפס
- `alephOmega`: קרדינל אינסופי מסדר אומגה

### פעולות על קרדינלים

- חיבור: `_⊕_`: מחבר שני קרדינלים
- כפל: `_⊗_`: כופל שני קרדינלים
- מינימום: `predC`: מפחית קרדינל בצעד אחד
- השוואה: `cardStronger`: האם קרדינל אחד גדול מהשני

## אלגברת אורות

אלגברת האורות היא מבנה אלגברי עשיר המאפיין את האינטראקציות והטרנספורמציות של אור בסימולציה. האלגברה מבוססת על הטיפוס `Light`:

```agda
record Light : Set (lsuc ℓ) where
  constructor mkLight
  field
    power     : Cardinal ℓ    -- עוצמת האור
    structure : Ordinal ℓ     -- מבנה/סדר האור
    category  : LightCategory -- קטגוריה (נרנח"י)
    kind      : LightKind     -- סוג (פנימי/מקיף)
    source    : String        -- מקור/זיהוי
    timestamp : Ordinal ℓ     -- זמן בסימולציה
```

### פעולות אלגבריות בסיסיות

- חיבור אורות: `_⊕L_`
  ```agda
  _⊕L_ : Light → Light → Light
  light₁ ⊕L light₂ = mkLight 
    (power light₁ ⊕ power light₂)                 -- חיבור קרדינלי
    (maxO (structure light₁) (structure light₂))  -- מקסימום מבנה
    (mergeCategories (category light₁) (category light₂)) -- מיזוג קטגוריות
    (dominantKind (kind light₁) (kind light₂))    -- קביעת סוג דומיננטי
    (source light₁ ++ "+" ++ source light₂)       -- מקור משולב
    (maxO (timestamp light₁) (timestamp light₂))   -- חותמת זמן עדכנית
  ```

- כפל אורות: `_⊗L_`
  ```agda
  _⊗L_ : Light → Light → Light
  light₁ ⊗L light₂ = mkLight 
    (power light₁ ⊗ power light₂)                 -- כפל קרדינלי
    (maxO (structure light₁) (structure light₂))   -- מקסימום מבנה
    (interactCategories (category light₁) (category light₂)) -- אינטראקציה קטגוריות
    (interactKinds (kind light₁) (kind light₂))   -- אינטראקציה סוגים
    (source light₁ ++ "*" ++ source light₂)       -- מקור משולב
    (maxO (timestamp light₁) (timestamp light₂))   -- חותמת זמן עדכנית
  ```

### הנחתת אור

מנגנון ה`AttenuationFactor` מגדיר כיצד להפחית עוצמת אור בעת העברתו דרך כלים:

```agda
record AttenuationFactor : Set (lsuc ℓ) where
  constructor mkAttenuation
  field
    powerFactor     : Cardinal ℓ    -- פקטור הפחתת עוצמה
    structureFactor : Ordinal ℓ     -- פקטור הפחתת מבנה
    qualityChange   : LightCategory → LightCategory -- שינוי איכות
    preserveKind    : Bool          -- האם לשמר את סוג האור
```

פונקציות הנחתה מיוחדות לטיפול בקרדינלים ואורדינלים אינסופיים:
- `attenuatePower`: הנחתת עוצמה - טיפול מיוחד באינסופיים
- `attenuateStructure`: הנחתת מבנה - טיפול באורדינלים

### תכונות אלגבריות

האלגברה מקיימת תכונות קריטיות כגון:
- איבר אפס: `zeroLight` - איבר ניטרלי לחיבור
- איבר יחידה: `oneLight` - איבר ניטרלי לכפל
- קומוטטיביות חיבור וכפל
- אסוציאטיביות חיבור וכפל
- פילוג של כפל על פני חיבור

## מתמטיקת הכלים

כלי (Keli) הוא מיכל שמסוגל להכיל ולעבד אור. ההגדרה הפורמלית:

```agda
record Keli : Set (lsuc ℓ) where
  field
    seph     : SefirahId      -- זיהוי ספירה 
    kind     : VesselKind     -- סוג כלי (פנימי/חיצוני)
    substance : KeliSubstance  -- חומר הכלי (זהב/כסף/נחושת)
    capacity : Cardinal ℓ     -- קיבולת הכלי
    content  : Light          -- תוכן האור הנמצא בכלי
    breaking : Maybe Light    -- אור שגורם שבירה (אם יש)
```

### חומרי כלים ומאפייניהם

חומרי הכלים משפיעים ישירות על אופן העברת האור:

```agda
createAttenuationFactor : KeliSubstance → AttenuationFactor
createAttenuationFactor Zahav = mkAttenuation 
  (fin 1)                 -- הפחתה מינימלית בזהב
  zero                    -- אין הפחתת מבנה משמעותית
  (λ cat → cat)           -- לא משנה את הקטגוריה
  true                    -- שומר על סוג האור
createAttenuationFactor Kesef = mkAttenuation 
  (fin 2)                 -- הפחתה בינונית בכסף
  (succ zero)             -- הפחתה קלה במבנה
  (λ cat → ...)           -- הורדת קטגוריה במקרים מסוימים
  true                    -- שומר על סוג האור
createAttenuationFactor Nechoshet = mkAttenuation 
  (fin 3)                 -- הפחתה משמעותית בנחושת
  (succ (succ zero))      -- הפחתה משמעותית במבנה
  (λ cat → ...)           -- ירידה של רמה בכל הקטגוריות
  false                   -- עלול לשנות את סוג האור
```

## יחסי גומלין אור-כלי

האינטראקציה בין אור וכלי היא המהות של הסימולציה ומוגדרת בקפידה:

### העברת אור דרך כלי

```agda
attenuateThroughKeli : Light → Keli → Light
attenuateThroughKeli light keli = 
  let factor = createAttenuationFactor (substance keli)
  in attenuate light factor
```

### אור מקיף (עודף)

```agda
createSurroundingLight : Light → Keli → Light
createSurroundingLight light keli = surroundingLight
  where
    hasExcessPower : Bool
    hasExcessPower = cardStronger (power light) (capacity keli)
    
    excessPower : Cardinal ℓ
    excessPower = attenuatePower (power light) (capacity keli)
    
    surroundingLight : Light
    surroundingLight = 
      if hasExcessPower
      then mkLight 
           excessPower
           (structure light)
           (category light)
           Makif
           (source light ++ "-surrounding")
           (timestamp light)
      else zeroLight
```

### הדלפת אור (שבירה)

```agda
leakLight : Light → Keli → Light
leakLight light keli = leakedLight
  where
    originalLight : Light
    originalLight = content keli
    
    combinedLight : Light
    combinedLight = light ⊕L originalLight
    
    hasOverflow : Bool
    hasOverflow = cardStronger (power combinedLight) (capacity keli)
    
    leakAmount : Cardinal ℓ
    leakAmount = attenuatePower (power combinedLight) (capacity keli)
    
    leakedLight : Light
    leakedLight = 
      if hasOverflow
      then mkLight
           leakAmount
           (structure combinedLight)
           (category combinedLight)
           (kind combinedLight)
           (source combinedLight ++ "-leaked")
           (timestamp combinedLight)
      else zeroLight
```

## צמצום וטרנספורמציות

הצמצום הראשון מתואר כטרנספורמציה מתמטית מאינסוף-לא-תפיס לאינסוף ריק:

```agda
tzimtzumRishon : EinSof → Cardinal ℓ → EmptySpace
tzimtzumRishon _ radius = mkEmptySpace 
  (aleph omega) -- הקוטר האינסופי של החלל הפנוי
  radius        -- רדיוס החלל (קרדינל אינסופי)
```

השלבים העיקריים בהשתלשלות:
1. **אור אינסוף (Ein Sof)** - מיוצג כאיבר יחידי מטיפוס `EinSof`
2. **צמצום (Tzimtzum)** - טרנספורמציה מ-∞ ל-0 (ריקנות)
3. **הכנסת הקו (Kav)** - הכנסת אור (fin 1) לחלל
4. **עקודים (Akudim)** - האור ממלא כלים, החל תהליך דינמי
5. **נקודים (Nekudim)** - אור חזק מדי, שבירת הכלים
6. **תיקון (Tikkun)** - בניית כלים חדשים, זרימת שפע נכונה

## עקרונות פורמליים

הפרויקט מתבסס על עקרונות מתמטיים מחמירים:

### שימוש ב-`--without-K`

אנו משתמשים בדגל `--without-K` להסרת אקסיומת K של שטרייכר, המאפשר:
- תאימות עם תורת הטיפוסים ההומוטופית (HoTT)
- תאימות עם אקסיומת האוניוולנטיות
- גישה קונסטרוקטיבית יותר לשוויון ומבנים מתמטיים

### מבנים אלגבריים לניתוח

המערכת תומכת במבנים אלגבריים חזקים ויחסים ביניהם:
- אלגברת אורות עם איברי אפס ויחידה
- מבנה חצי-מודול (semi-module) עבור פעולות על אור
- יחסי חיבור וכפל מוגדרים במדויק
- תמיכה בקרדינלים ואורדינלים טרנספיניטיים

### חישובים טרנספיניטיים

המערכת מאפשרת חישובים עם ערכים אינסופיים:

```agda
aleph0PlusAleph0 : Cardinal ℓ
aleph0PlusAleph0 = aleph0 ⊕ aleph0  -- שווה לaleph0

aleph0TimesAleph0 : Cardinal ℓ
aleph0TimesAleph0 = aleph0 ⊗ aleph0  -- שווה לaleph0

-- אורות אינסופיים
infiniteLight : Light
infiniteLight = mkLight aleph0 omega Neshama Pnimi "infinite" zero
```

## סיכום

המודל המתמטי של EtzChaim מציע פורמליזציה קפדנית של מושגים קבליים כאור, כלי, ספירות ועולמות. 
המימוש בAgda תומך בקרדינלים ואורדינלים טרנספיניטיים, כמו גם באלגברה שלמה של פעולות על אור. 
שילוב זה מאפשר סימולציה מדויקת של ההשתלשלות, כולל שלבי הצמצום, השבירה והתיקון.

המערכת נבנתה תוך שימוש בעקרונות מחמירים של תורת הטיפוסים ההומוטופית, דבר המאפשר הרחבה עתידית וחיבור למודלים מתמטיים אחרים. 