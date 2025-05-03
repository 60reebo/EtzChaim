--------------------------------------------------
-- OhrPnimiMakif (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Light.OhrPnimiMakif where

-- | OhrPnimiMakif (אור פנימי/מקיף):
-- טיפוסי אור פנימי ואור מקיף לפי הקבלה.


open import Data.Nat

data OhrType : Set where
  Pnimi : OhrType
  Makif : OhrType

record Ohr : Set where
  field
    typ      : OhrType
    strength : ℕ
    position : ℕ
