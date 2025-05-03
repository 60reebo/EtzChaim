module Hishtalshelut.Domain.Worlds.Kav where

-- | Kav (קו):
-- ייצוג הקו הישר במערכת ההשתלשלות, מושג יסוד בקבלה.

-- קו (ישר)

open import Data.Nat

record Kav : Set where
  field
    start : ℕ
    length : ℕ
    direction : ℕ
