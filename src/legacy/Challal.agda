--------------------------------------------------
-- Challal (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Worlds.Challal where

-- | Challal (חלל פנוי):
-- ייצוג החלל שנוצר לאחר הצמצום, מושג יסוד בתורת הקבלה.
-- EmptySpace – חלל ריק, FilledSpace – חלל ממולא באור.

open import Data.Nat

record Challal : Set where
  field
    center : ℕ
    radius : ℕ
