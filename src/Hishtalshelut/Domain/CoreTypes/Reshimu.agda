--------------------------------------------------
-- CoreTypes/Reshimu (Domain Layer)
--------------------------------------------------
open import Agda.Primitive using (Level; lsuc)
module Hishtalshelut.Domain.CoreTypes.Reshimu (ℓ : Level) where

open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal)
open import Agda.Builtin.String using (String)

-- | The Reshimu represents the trace or potential left after Tzimtzum.
--   It is not actual light, but a formal potential for future creation.
record Reshimu : Set (lsuc ℓ) where
  constructor mkReshimu
  field
    potentialPower     : Cardinal ℓ    -- Cardinal potential for future vessels/light
    potentialStructure : Ordinal ℓ     -- Ordinal memory/structure from Ein Sof
    source             : String      -- Source/identifier (מקור/זיהוי הרשימו)
