--------------------------------------------------
-- TzimtzumState (State Layer)
--------------------------------------------------
module Hishtalshelut.State.Worlds.TzimtzumState where

open import Hishtalshelut.Domain.Worlds.Tzimtzum public using (TzimtzumStatus; WillForCreation; ReshimuLevel; ContractionStep)
open import Hishtalshelut.State.Worlds.EinSofState public using (EinSofState; initialEinSofState)
open import Agda.Builtin.Bool public using (Bool; true; false)

-- | Combined state for the contraction process
record ContractionState : Set where
  field
    einSofState : EinSofState
    will        : WillForCreation
    status      : TzimtzumStatus
    hasLight    : Bool

open ContractionState public

-- | Initial state before contraction: full light
initialContractionState : EinSofState → ContractionState
initialContractionState es = record { einSofState = es ; will = WillForCreation.NoWill ; status = TzimtzumStatus.NoTzimtzum ; hasLight = true }

-- | State after contraction: no light
afterContractionState : ContractionState → ContractionState
afterContractionState c = record c { will = WillForCreation.PotentialWill ; status = TzimtzumStatus.AfterTzimtzum ; hasLight = false }
