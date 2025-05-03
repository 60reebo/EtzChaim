--------------------------------------------------
-- CoreTypes/Connection (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.CoreTypes.Connection (ℓ : Level) where

open import Agda.Primitive using (Level ; lsuc)
open import Data.Maybe using (Maybe)
open import Agda.Builtin.String using (String)
open import Hishtalshelut.Domain.CoreTypes.Ids using (PartzufId)
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal)

-- | Connection between Partzufs (edges in emanation graph)
record Connection : Set (lsuc ℓ) where
  constructor mkConnection
  field
    source   : PartzufId       -- Source Partzuf identifier
    target   : PartzufId       -- Target Partzuf identifier
    strength : Cardinal ℓ      -- Connection strength (עוצמה)
    note     : Maybe String    -- Optional note/label
