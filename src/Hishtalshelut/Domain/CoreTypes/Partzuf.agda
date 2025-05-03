--------------------------------------------------
-- CoreTypes/Partzuf (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.CoreTypes.Partzuf (ℓ : Agda.Primitive.Level) where

open import Agda.Primitive using (Level ; lsuc)
open import Data.List using (List)
open import Hishtalshelut.Domain.CoreTypes.Ids using (PartzufId)
open import Hishtalshelut.Domain.Worlds.IgulimYosher using (Sefirah)
open import Hishtalshelut.Domain.CoreTypes.Light using (Light)

-- | Hierarchical entity (Partzuf) in the emanation tree
record Partzuf (ℓ : Level) : Set (lsuc ℓ) where
  constructor mkPartzuf
  field
    id           : PartzufId
    seph         : Sefirah
    currentLight : Light ℓ
    children     : List PartzufId
