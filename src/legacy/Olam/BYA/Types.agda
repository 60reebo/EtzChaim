module Hishtalshelut.State.Olam.BYA.Types where

open import Agda.Primitive public
open import Agda.Builtin.Nat public using (Nat)
open import Agda.Builtin.List public using (List; [])
open import Data.Maybe using (Maybe)
open import Hishtalshelut.Domain.All public

-- World names

data BYAWorldName : Set where
  Beriah   : BYAWorldName
  Yetzirah : BYAWorldName
  Assiah   : BYAWorldName

-- State of a single world
record WorldLevelState : Set where
  constructor mkWLS
  field
    residentSparks : List Spark
    klippotLevel   : Nat
    receivedShefa  : LightLevel

-- State of all BYA worlds
OlamBYAState : Set
OlamBYAState = BYAWorldName -> WorldLevelState
