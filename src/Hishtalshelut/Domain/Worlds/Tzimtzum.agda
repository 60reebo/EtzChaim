{-# OPTIONS --without-K #-}
--------------------------------------------------
-- Tzimtzum (Domain Layer)
--------------------------------------------------
open import Agda.Primitive using (Level; lzero; lsuc)
module Hishtalshelut.Domain.Worlds.Tzimtzum (ℓ : Level) where

open import Agda.Builtin.Bool
open import Agda.Builtin.Unit
open import Agda.Builtin.Nat using (Nat)
open import Agda.Builtin.List using (List; []; _∷_)
open import Agda.Builtin.Maybe using (Maybe; just; nothing)
open import Agda.Builtin.String using (String)

open import Hishtalshelut.Domain.Worlds.IgulimYosherReshimu ℓ using (ReshimuSpec)
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; fin; aleph)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; limit; omega)

-- | סטטוס הצמצום
data TzimtzumStatus : Set where
   NoTzimtzum   : TzimtzumStatus    -- לפני הצמצום
   InProgress   : TzimtzumStatus    -- במהלך הצמצום
   AfterTzimtzum : TzimtzumStatus   -- אחרי השלמת הצמצום

-- | רצון לבריאה (פוטנציאלי)
data WillForCreation : Set where
  NoWill : WillForCreation          -- אין רצון לבריאה
  PotentialWill : WillForCreation   -- רצון פוטנציאלי לבריאה

-- | רשימו (רושם דק של אור)
data ReshimuLevel : Set where
  NoReshimu : ReshimuLevel         -- אין רשימו
  PartialReshimu : ReshimuLevel    -- רשימו חלקי
  CompleteReshimu : ReshimuLevel   -- רשימו מלא

-- | שלבי תהליך הצמצום
data ContractionStep : Set (lsuc ℓ) where
   StepStartEinSof     : ContractionStep            -- התחלה באין-סוף
   StepPotentialWill   : ContractionStep            -- הופעת הרצון
   StepExecuteTzimtzum : Ordinal ℓ → ContractionStep  -- ביצוע צמצום עם פרמטר אורדינלי
   StepLeaveReshimu    : Ordinal ℓ → ContractionStep  -- הטבעת רשימו בשכבה אורדינלית

-- | נקודת אמצע לצמצום
data CenterPoint : Set where
  Midpoint : CenterPoint      -- נקודת האמצע של העיגול

-- | מפרט הצמצום כולל מרכז ורדיוס מקסימלי אורדינלי
record TzimtzumSpec : Set ℓ where
  field
    center     : CenterPoint   -- נקודת מרכז הצמצום
    maxRadius  : Ordinal ℓ     -- רדיוס מקסימלי (אורדינלי)
    lightSource : String       -- מקור האור המקורי

-- | צורת עיגול במערכת הצמצום
record CircleShape : Set (lsuc ℓ) where
  field
    center    : CenterPoint
    radius    : Ordinal ℓ      -- רדיוס אורדינלי
    
-- | מפרט שכבה אורדינלית של צמצום
record OrdinalLayer : Set (lsuc ℓ) where
  field
    index     : Ordinal ℓ      -- אינדקס אורדינלי של השכבה
    reshimu   : Maybe ReshimuSpec  -- רשימו שנוצר בשכבה זו
    isEmpty   : Bool           -- האם השכבה ריקה מאור

-- | מספור שלבי הצמצום עם ערך אורדינלי
record ContractionPhase : Set (lsuc ℓ) where
  field
    step      : ContractionStep    -- סוג הצעד
    phaseIndex : Ordinal ℓ         -- מיקום אורדינלי של הצעד בסדר הצעדים

-- | פונקציה עזר לחישוב אינדקס אורדינלי חדש בצעד הבא
nextOrdinalStep : Ordinal ℓ → Ordinal ℓ
nextOrdinalStep = succ

-- | האם אורדינל הוא בגבולות אומגה (ω)
isWithinOmega : Ordinal ℓ → Bool
isWithinOmega ordinal = true  -- פשטות: מניחים כרגע שכל אורדינל הוא בגבולות אומגה
                                                                                                  