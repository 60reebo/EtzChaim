--------------------------------------------------
-- Ordinal (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Ordinal where

open import Agda.Builtin.String using (String)
import Data.String.Base as Str using (_++_)

open import Data.Nat using (ℕ; zero; suc)
open import Data.Bool using (Bool; true; false)
open import Data.Unit.Polymorphic.Base public using (⊤ ; tt)

open import Hishtalshelut.Domain.Math.Ordinal public using (Ordinal; zero; succ; limit; omega; iterate; ordinalEq; showOrdinal)
