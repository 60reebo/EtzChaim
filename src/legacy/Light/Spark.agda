--------------------------------------------------
-- Spark (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Light.Spark where

open import Data.Nat

record Spark : Set where
  field
    position  : ℕ
    intensity : ℕ

