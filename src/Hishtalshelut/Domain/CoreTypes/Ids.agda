--------------------------------------------------
-- CoreTypes/Ids (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.CoreTypes.Ids where

open import Agda.Primitive using (Level)
open import Data.Nat using (ℕ)

-- | Identifier for Partzuf (configuration/persona)
data PartzufId : Set where
  mkPartzufId : ℕ → PartzufId

-- | Identifier for Keli (tool)
data KeliId : Set where
  mkKeliId : ℕ → KeliId

-- | Identifier for World/Olam
data OlamId : Set where
  mkOlamId : ℕ → OlamId

-- | Identifier for Sefirah
data SefirahId : Set where
  mkSefirahId : ℕ → SefirahId
