--------------------------------------------------
-- Sefira (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Worlds.Sefira where

open import Data.Nat

-- סדר הספירות (כמעגלים או כיושר)
data SefiraOrder : Set where
  Igulim : SefiraOrder  -- עיגולים
  Yosher  : SefiraOrder  -- יושר

-- טיפוס מתמטי לספירה
record Sefira : Set where
  field
    order : SefiraOrder
    level : ℕ
    value : ℕ
