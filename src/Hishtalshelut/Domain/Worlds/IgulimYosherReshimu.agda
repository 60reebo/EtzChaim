{-# OPTIONS --without-K #-}
--------------------------------------------------
-- ReshimuSpec (Domain Layer for IgulimYosher)
--------------------------------------------------
open import Agda.Primitive using (Level; lsuc)
module Hishtalshelut.Domain.Worlds.IgulimYosherReshimu (ℓ : Level) where

open import Agda.Builtin.Nat using (Nat; suc)
open import Hishtalshelut.Domain.Worlds.IgulimYosher ℓ using (Sefirah; VesselKind; SefirahUnit; CircleSpec)
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; fin)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; limit; omega; predO; fromNatO; showOrdinal; iterate; isLimit)
open import Hishtalshelut.Domain.CoreTypes.Light ℓ
open import Agda.Builtin.String using (String)
open import Agda.Builtin.Maybe using (Maybe; just; nothing)
open SefirahUnit public
open CircleSpec public

-- | קטגוריות איכות הרשימו
data ReshimuQuality : Set ℓ where
  Kelim_Root_Potential : ReshimuQuality  -- פוטנציאל לכלים
  Original_Light_Trace : ReshimuQuality  -- שארית אור מקורי
  Structure_Imprint    : ReshimuQuality  -- טביעת מבנה
  Empty                : ReshimuQuality  -- ריק לגמרי

-- | Reshimu imprint specification - transfinite version
-- | רשימו מפורט עם שימוש בטרנספיניטים
record ReshimuSpec : Set (lsuc ℓ) where
  field
    seph               : Sefirah              -- שיוך לספירה
    vesselInner        : VesselKind           -- סוג כלי פנימי
    vesselOuter        : VesselKind           -- סוג כלי חיצוני
    potential_power    : Cardinal ℓ           -- עוצמה פוטנציאלית (בד"כ fin 0)
    inherited_structure : Ordinal ℓ            -- מבנה אורדינלי שנירש מהאור המקורי
    quality            : ReshimuQuality       -- איכות מיוחדת של הרשימו
    original_light_ref : Maybe Light          -- הפניה לאור שיצר את הרשימו (אופציונלי)
    layer_index        : Ordinal ℓ            -- אינדקס השכבה האורדינלית בה נמצא הרשימו
    source             : String               -- מקור הרשימו

-- | Convert a SefirahUnit to a Reshimu imprint spec - with transfinite properties
toReshimuSpec : SefirahUnit → ReshimuSpec
toReshimuSpec su = record
  { seph               = seph (circle su)
  ; vesselInner        = vesselInner (circle su)
  ; vesselOuter        = vesselOuter (circle su)
  ; potential_power    = fin {ℓ} 0
  ; inherited_structure = fromNatO 0
  ; quality            = Kelim_Root_Potential
  ; original_light_ref = nothing
  ; layer_index        = fromNatO 0
  ; source             = "base-reshimu"
  }

-- | חיסור אורדינלים פשוט
minusOrdinal : Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
minusOrdinal x zero      = x
minusOrdinal x (succ n)  = predO (minusOrdinal x n)
minusOrdinal x (limit f) = limit (λ n → minusOrdinal x (f n))

-- | פונקציה עזר להמרה מאורדינל סופי ל-Nat
ordinalToNat : ∀ {ℓ} → Ordinal ℓ → Nat
ordinalToNat zero = 0
ordinalToNat (succ o) = suc (ordinalToNat o)
ordinalToNat (limit f) = 0 -- מניחים שאין לנו limit במקרה הזה

-- | חישוב מבנה רשימו לפי שכבה אורדינלית
computeReshimuStructure : Light → Ordinal ℓ → Ordinal ℓ → Ordinal ℓ
computeReshimuStructure light layerOrd maxOrd =
  iterate succ (suc (ordinalToNat layerOrd)) omega

-- | יצירת רשימו מתקדם יותר מאור קיים
createReshimuFromLight : Light → Ordinal ℓ → Ordinal ℓ → ReshimuSpec
createReshimuFromLight light layerOrd maxOrd = record
  { seph               = Sefirah.Keter
  ; vesselInner        = VesselKind.InnerVessel
  ; vesselOuter        = VesselKind.OuterVessel
  ; potential_power    = fin {ℓ} 0
  ; inherited_structure = computeReshimuStructure light layerOrd maxOrd
  ; quality            = Kelim_Root_Potential
  ; original_light_ref = just light
  ; layer_index        = layerOrd
  ; source             = source light
  }

-- | תצוגה קריאה של מבנה רשימו: ω+N (דינמי)
showReshimuStructure : Ordinal ℓ → String
showReshimuStructure o =
  if isLimit o then
    showOrdinal o
  else
    showOrdinal o

  