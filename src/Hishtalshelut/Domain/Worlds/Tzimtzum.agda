--------------------------------------------------
-- Tzimtzum (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Worlds.Tzimtzum where

open import Agda.Builtin.Bool
open import Agda.Builtin.Unit

-- | סטטוס הצמצום
data TzimtzumStatus : Set where
   NoTzimtzum   : TzimtzumStatus
   AfterTzimtzum : TzimtzumStatus

-- | רצון לבריאה (פוטנציאלי)
data WillForCreation : Set where
  NoWill : WillForCreation
  PotentialWill : WillForCreation

-- | רשימו (רושם דק של אור)
data ReshimuLevel : Set where
  NoReshimu : ReshimuLevel
  WithReshimu : ReshimuLevel

-- | steps enumeration
data ContractionStep : Set where
   StepStartEinSof     : ContractionStep
   StepPotentialWill   : ContractionStep
   StepExecuteTzimtzum : ContractionStep
   StepLeaveReshimu    : ContractionStep
