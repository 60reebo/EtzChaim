--------------------------------------------------
-- TzimtzumEngine (Engine Layer)
--------------------------------------------------
module Hishtalshelut.Engine.Worlds.TzimtzumEngine where

open import Agda.Builtin.Unit public using (⊤; tt)
open import Data.List public using (List; _∷_; [])
open import Data.String public using (String)
open import Hishtalshelut.Domain.Worlds.Tzimtzum public using (TzimtzumStatus; WillForCreation; ReshimuLevel; ContractionStep)
open import Hishtalshelut.Rules.Worlds.Tzimtzum public using (startWithFullEinSof; potentialWillForCreation; executeTzimtzum; leaveReshimu; buildContractionSteps)
open import Hishtalshelut.State.Worlds.TzimtzumState public using (ContractionState)

-- | Associate each contraction step with a textual description
stepToText : ContractionStep -> String
stepToText StepStartEinSof     = "Start with Infinite EinSof"
stepToText StepPotentialWill   = "Potential Will for Creation"
stepToText StepExecuteTzimtzum = "Execute Tzimtzum (constriction)"
stepToText StepLeaveReshimu    = "Leave Reshimu (Reshimu Phase)"

-- | Simulation trace: list of intermediate states
simulateTzimtzumTrace : ⊤ -> List ContractionState
simulateTzimtzumTrace _ =
  let s0 = startWithFullEinSof tt
      s1 = potentialWillForCreation s0
      s2 = executeTzimtzum s1
      s3 = leaveReshimu s2
  in s0 ∷ s1 ∷ s2 ∷ s3 ∷ []

-- | Final state after full contraction
simulateTzimtzum : ⊤ -> ContractionState
simulateTzimtzum _ = leaveReshimu (executeTzimtzum (potentialWillForCreation (startWithFullEinSof tt)))
