{-# OPTIONS --no-main #-}
--------------------------------------------------
-- אלגברת אורות (Math/LightAlgebra)
--------------------------------------------------
module Hishtalshelut.Domain.Math.LightAlgebra (ℓ : Agda.Primitive.Level) where

open import Agda.Primitive using (Level; lzero; lsuc)
open import Agda.Builtin.Bool using (Bool; true; false)
open import Agda.Builtin.String using (String)
open import Data.Bool using (_∧_; _∨_; if_then_else_)
open import Data.List using (List; []; _∷_; foldr)
open import Data.Nat using (ℕ; zero; suc; _≤_; _<_; _+_; _*_; _>_; _∸_)
open import Data.Nat.Properties using (_≤?_; _<?_; _>?_)
open import Data.Maybe using (Maybe; just; nothing)
open import Data.Product using (_×_; _,_; proj₁; proj₂)
open import Data.String.Base using (_++_)
open import Relation.Binary.PropositionalEquality using (_≡_; refl; cong; sym; trans)
open import Relation.Nullary.Decidable using (⌊_⌋)

-- יבוא ממודולים מתמטיים
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; fin; aleph; _⊕_; _⊗_; index)
open import Hishtalshelut.Domain.Math.Cardinal.Properties using (cardStronger)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; limit; fromNatO; maxO)
open import Hishtalshelut.Domain.Math.Ordinal.Properties using (ordStronger)

-- יבוא מודלים של אור
open import Hishtalshelut.Domain.CoreTypes.Light ℓ using (Light; mkLight; power; structure; category; kind; source; timestamp)
open import Hishtalshelut.Domain.CoreTypes.Keli ℓ using (Keli; capacity; content; substance; seph; kind)
open import Hishtalshelut.Domain.Worlds.IgulimYosher ℓ
  using (LightCategory; Nefesh; Ruach; Neshama; Chaya; Yechida; Undifferentiated_LightCategory;
         LightKind; Pnimi; Makif)
open import Hishtalshelut.Domain.Kelim.KeliSubstance using (KeliSubstance; Zahav; Kesef; Nechoshet)

--------------------------------------------------
-- פונקציות עזר
--------------------------------------------------

-- | השוואת שוויון קטגוריות אור - החזרת בוליאן
_≟LC_ : LightCategory → LightCategory → Bool
Undifferentiated_LightCategory ≟LC Undifferentiated_LightCategory = true
Nefesh ≟LC Nefesh = true
Ruach ≟LC Ruach = true
Neshama ≟LC Neshama = true
Chaya ≟LC Chaya = true
Yechida ≟LC Yechida = true
_ ≟LC _ = false

-- | השוואת שוויון סוגי אור - החזרת בוליאן
_≟LK_ : LightKind → LightKind → Bool
Pnimi ≟LK Pnimi = true
Makif ≟LK Makif = true
_ ≟LK _ = false

-- | מיזוג קטגוריות אור
-- הכלל: במיזוג לוקחים את הקטגוריה הגבוהה יותר
mergeCategories : LightCategory → LightCategory → LightCategory
mergeCategories Undifferentiated_LightCategory cat = cat
mergeCategories cat Undifferentiated_LightCategory = cat
mergeCategories Nefesh Nefesh = Nefesh
mergeCategories Nefesh Ruach = Ruach
mergeCategories Nefesh Neshama = Neshama
mergeCategories Nefesh Chaya = Chaya
mergeCategories Nefesh Yechida = Yechida
mergeCategories Ruach Nefesh = Ruach
mergeCategories Ruach Ruach = Ruach
mergeCategories Ruach Neshama = Neshama
mergeCategories Ruach Chaya = Chaya
mergeCategories Ruach Yechida = Yechida
mergeCategories Neshama Nefesh = Neshama
mergeCategories Neshama Ruach = Neshama
mergeCategories Neshama Neshama = Neshama
mergeCategories Neshama Chaya = Chaya
mergeCategories Neshama Yechida = Yechida
mergeCategories Chaya Nefesh = Chaya
mergeCategories Chaya Ruach = Chaya
mergeCategories Chaya Neshama = Chaya
mergeCategories Chaya Chaya = Chaya
mergeCategories Chaya Yechida = Yechida
mergeCategories Yechida _ = Yechida
mergeCategories _ Yechida = Yechida

-- | קביעת סוג האור הדומיננטי בעת מיזוג
-- כלל: אם אחד מקיף והשני פנימי, התוצאה מקיף
dominantKind : LightKind → LightKind → LightKind
dominantKind Pnimi Pnimi = Pnimi
dominantKind Makif _ = Makif
dominantKind _ Makif = Makif

-- | אינטראקציה בין קטגוריות אור
-- בדומה למיזוג, אך מיועד לפעולת כפל
interactCategories : LightCategory → LightCategory → LightCategory
interactCategories = mergeCategories  -- במימוש זה נשתמש באותה לוגיקה למיזוג ואינטראקציה

-- | אינטראקציה בין סוגי אור
-- בדומה לסוג דומיננטי, אך מיועד לפעולת כפל
interactKinds : LightKind → LightKind → LightKind
interactKinds = dominantKind  -- במימוש זה נשתמש באותה לוגיקה לסוג דומיננטי

-- | דירוג קטגוריות אור (למטרות השוואה)
categoryRank : LightCategory → ℕ
categoryRank Undifferentiated_LightCategory = 0
categoryRank Nefesh = 1
categoryRank Ruach = 2
categoryRank Neshama = 3
categoryRank Chaya = 4
categoryRank Yechida = 5

-- | השוואת קטגוריות אור
isCategoryStronger : LightCategory → LightCategory → Bool
isCategoryStronger cat1 cat2 = ⌊ categoryRank cat1 >? categoryRank cat2 ⌋

--------------------------------------------------
-- פעולות אלגבריות בסיסיות על אורות
--------------------------------------------------

-- | חיבור אורות: חיבור קרדינלי של power, maxO של structure
_⊕L_ : Light → Light → Light
light₁ ⊕L light₂ = mkLight 
  (power light₁ ⊕ power light₂)                 -- חיבור קרדינלי סטנדרטי
  (maxO (structure light₁) (structure light₂))  -- המבנה הגבוה ביותר
  (mergeCategories (category light₁) (category light₂)) -- מיזוג קטגוריות
  (dominantKind (kind light₁) (kind light₂))    -- קביעת סוג דומיננטי
  (source light₁ ++ "+" ++ source light₂)       -- מקור משולב
  (maxO (timestamp light₁) (timestamp light₂))   -- החותמת העדכנית ביותר

-- | כפל אורות: כפל קרדינלי של power, maxO של structure
_⊗L_ : Light → Light → Light
light₁ ⊗L light₂ = mkLight 
  (power light₁ ⊗ power light₂)                 -- כפל קרדינלי סטנדרטי
  (maxO (structure light₁) (structure light₂))   -- המבנה הגבוה ביותר
  (interactCategories (category light₁) (category light₂)) -- אינטראקציה של קטגוריות
  (interactKinds (kind light₁) (kind light₂))   -- אינטראקציה של סוגים
  (source light₁ ++ "*" ++ source light₂)       -- מקור משולב
  (maxO (timestamp light₁) (timestamp light₂))   -- החותמת העדכנית ביותר

-- | גורם הנחתה: מגדיר כיצד להפחית אור
record AttenuationFactor : Set (lsuc ℓ) where
  constructor mkAttenuation
  field
    powerFactor     : Cardinal ℓ    -- פקטור הפחתת עוצמה
    structureFactor : Ordinal ℓ     -- פקטור הפחתת מבנה
    qualityChange   : LightCategory → LightCategory -- שינוי איכות
    preserveKind    : Bool          -- האם לשמר את סוג האור

-- | פונקציית הנחתת עוצמה - טיפול מיוחד באינסופיים
attenuatePower : Cardinal ℓ → Cardinal ℓ → Cardinal ℓ
-- עבור עוצמות סופיות
attenuatePower (fin n) (fin m) = 
  if ⌊ n ≤? m ⌋ 
  then fin 0 
  else fin (n ∸ m)
-- עוצמה סופית ופקטור אינסופי
attenuatePower (fin _) (aleph _) = fin 0
-- עוצמה אינסופית ופקטור סופי
attenuatePower (aleph α) (fin _) = aleph α
-- שני אינסופיים - מימוש פשוט שמשאיר את האלף אבל מוריד ב-1 את האינדקס
attenuatePower (aleph (succ α)) (aleph _) = aleph α
attenuatePower (aleph zero) (aleph _) = fin 0
attenuatePower (aleph (limit f)) (aleph _) = aleph (f 0) -- פשטות: לוקחים את הערך הראשון בסדרה

-- | פונקציית הנחתת מבנה - טיפול באורדינלים
attenuateStructure : Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
-- אורדינלים סופיים
attenuateStructure zero _ = zero
attenuateStructure (succ α) (succ β) = 
  if ordStronger α β 
  then zero
  else α
attenuateStructure (succ α) zero = succ α
-- גבול
attenuateStructure (limit f) β = 
  if ordStronger (f 0) β 
  then zero
  else f 0
-- מקרים נוספים שמשתמשים בhigher-order function
attenuateStructure α (limit f) = 
  attenuateStructure α (f 0)  -- פשטות: משתמשים בערך הראשון בסדרת הגבול

-- | הנחתת סוג האור: בברירת מחדל משאירים את הסוג כמו שהוא
attenuateKind : LightKind → LightKind
attenuateKind k = k  -- אפשר להרחיב בעתיד אם יש צורך בשינוי הסוג

-- | הנחתה מלאה של האור לפי גורם ההנחתה
attenuate : Light → AttenuationFactor → Light
attenuate light factor = mkLight
  (attenuatePower (power light) (AttenuationFactor.powerFactor factor))
  (attenuateStructure (structure light) (AttenuationFactor.structureFactor factor))
  (AttenuationFactor.qualityChange factor (category light))
  (if AttenuationFactor.preserveKind factor 
   then kind light 
   else attenuateKind (kind light))
  (source light ++ "-attenuated")
  (timestamp light)

--------------------------------------------------
-- איברים מיוחדים
--------------------------------------------------

-- | איבר אפס לפעולת החיבור
zeroLight : Light
zeroLight = mkLight 
  (fin 0) 
  zero 
  Undifferentiated_LightCategory 
  Pnimi 
  "zero" 
  zero

-- | איבר יחידה לפעולת הכפל
oneLight : Light
oneLight = mkLight 
  (fin 1) 
  (succ zero) 
  Nefesh  -- קטגוריה הכי בסיסית
  Pnimi 
  "one" 
  zero

--------------------------------------------------
-- פונקציות מתקדמות
--------------------------------------------------

-- | מיזוג מספר אורות ברשימה
mergeMany : List Light → Light → Light
mergeMany [] base = base
mergeMany (x ∷ xs) base = x ⊕L mergeMany xs base

-- | העצמת אור לפי חזקה
powerOf : Light → ℕ → Light
powerOf l zero = oneLight
powerOf l (suc zero) = l
powerOf l (suc n) = l ⊗L (powerOf l n)

-- | יחס עוצמה בין אורות - האם אור ראשון חזק יותר מהשני
isStrongerThan : Light → Light → Bool
isStrongerThan l₁ l₂ = 
  cardStronger (power l₁) (power l₂) ∧ 
  ordStronger (structure l₁) (structure l₂) ∧
  isCategoryStronger (category l₁) (category l₂)

-- | חישוב האור הממוצע בין שני אורות
-- השתמשנו בקירוב כאן: חצי מסכום העוצמות, המבנה הגבוה ביותר, קטגוריה חזקה יותר
averageLight : Light → Light → Light
averageLight l₁ l₂ = mkLight
  (fin (div (index (power l₁) + index (power l₂)) 2))  -- ממוצע פשוט של העוצמות
  (maxO (structure l₁) (structure l₂))                 -- המבנה הגבוה ביותר
  (mergeCategories (category l₁) (category l₂))        -- קטגוריה מוזגת
  (dominantKind (kind l₁) (kind l₂))                   -- סוג דומיננטי
  (source l₁ ++ "&" ++ source l₂)                      -- מקור משולב
  (maxO (timestamp l₁) (timestamp l₂))                  -- חותמת זמן עדכנית
  where
    -- עזר: חילוק פשוט לקירוב ממוצע
    div : ℕ → ℕ → ℕ
    div zero _ = zero
    div _ zero = zero
    div (suc n) (suc m) = suc (div n (suc m))

--------------------------------------------------
-- אינטגרציה עם כלים
--------------------------------------------------

-- | יצירת גורם הנחתה מותאם לסוג הכלי
createAttenuationFactor : KeliSubstance → AttenuationFactor
createAttenuationFactor Zahav = mkAttenuation 
  (fin 1)       -- הפחתה מינימלית בזהב (חומר איכותי)
  zero          -- אין הפחתת מבנה משמעותית
  (λ cat → cat) -- לא משנה את הקטגוריה
  true          -- שומר על סוג האור
createAttenuationFactor Kesef = mkAttenuation 
  (fin 2)       -- הפחתה בינונית בכסף
  (succ zero)   -- הפחתה קלה במבנה
  (λ cat →       -- קטגוריות גבוהות יותר יכולות לרדת רמה
    if isCategoryStronger cat Ruach
    then (if cat ≟LC Yechida
          then Chaya 
          else if cat ≟LC Chaya
               then Neshama
               else cat)
    else cat)
  true          -- שומר על סוג האור
createAttenuationFactor Nechoshet = mkAttenuation 
  (fin 3)       -- הפחתה משמעותית בנחושת (חומר פחות איכותי)
  (succ (succ zero)) -- הפחתה משמעותית במבנה
  (λ cat →       -- ירידה של רמה אחת בכל הקטגוריות מעל נפש
    if cat ≟LC Yechida
    then Chaya
    else if cat ≟LC Chaya
         then Neshama
         else if cat ≟LC Neshama
              then Ruach
              else if cat ≟LC Ruach
                   then Nefesh
                   else cat)
  false         -- עלול לשנות את סוג האור

-- | הנחתה של אור דרך כלי
attenuateThroughKeli : Light → Keli → Light
attenuateThroughKeli light keli = 
  let factor = createAttenuationFactor (substance keli)
  in attenuate light factor

-- | האור המקיף שנוצר כאשר אור חזק מדי מנסה להיכנס לכלי
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

-- | הדלפת אור מכלי כאשר הוא "שבור" או לא מסוגל להכיל את כל האור
leakLight : Light → Keli → Light
leakLight light keli = leakedLight
  where
    originalLight : Light
    originalLight = content keli
    
    combinedLight : Light
    combinedLight = light ⊕L originalLight
    
    hasOverflow : Bool
    hasOverflow = cardStronger (power combinedLight) (capacity keli)
    
    leakFactor : AttenuationFactor
    leakFactor = createAttenuationFactor (substance keli)
    
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

--------------------------------------------------
-- תכונות אלגבריות (הוכחות)
--------------------------------------------------

-- הערה: ההוכחות נמצאות בשלב פיתוח ויושלמו בעתיד
-- כאשר כל פונקציות הבסיס יהיו מוגדרות היטב

{- 
-- לדוגמה, הוכחות לתכונות שיידרשו לממש בעתיד:
--   * חיבור עם אור אפס משמר את האור המקורי (⊕L-zeroʳ, ⊕L-zeroˡ)
--   * כפל עם אור יחידה משמר את האור המקורי (⊗L-oneʳ, ⊗L-oneˡ)
--   * כפל עם אור אפס מניב אור אפס (⊗L-zeroʳ, ⊗L-zeroˡ)
--   * חיבור אורות הוא קומוטטיבי (⊕L-comm)
--   * כפל אורות הוא קומוטטיבי (⊗L-comm)
--   * חיבור וכפל אורות הם אסוציאטיביים (⊕L-assoc, ⊗L-assoc)
--   * כפל מפלג על חיבור משמאל ומימין (⊗L-distribˡ-⊕L, ⊗L-distribʳ-⊕L)
-}                                