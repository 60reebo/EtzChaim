module Hishtalshelut.Rules.Worlds.Tzimtzum where

-- stub: תבנית חוקים לצמצום בשכבות

open import Agda.Builtin.Unit public using (⊤; tt)
open import Data.List public using (List; _∷_; [])
open import Hishtalshelut.Domain.Worlds.Tzimtzum public using (TzimtzumStatus; NoTzimtzum; AfterTzimtzum;
    WillForCreation; NoWill; PotentialWill;
    ReshimuLevel; NoReshimu;
    ContractionStep; StepStartEinSof; StepPotentialWill; StepExecuteTzimtzum; StepLeaveReshimu)
open import Hishtalshelut.State.Worlds.TzimtzumState public using (ContractionState; initialContractionState; afterContractionState)
open import Hishtalshelut.State.Worlds.EinSofState public using (EinSofState; initialEinSofState)

startWithFullEinSof : ⊤ → ContractionState
startWithFullEinSof _ = initialContractionState initialEinSofState

potentialWillForCreation : ContractionState → ContractionState
potentialWillForCreation c = record c { will = PotentialWill }

executeTzimtzum : ContractionState → ContractionState
executeTzimtzum c = record c { status = AfterTzimtzum }

leaveReshimu : ContractionState → ContractionState
leaveReshimu = afterContractionState

buildContractionSteps : ⊤ → List ContractionStep
buildContractionSteps _ = StepStartEinSof ∷ StepPotentialWill ∷ StepExecuteTzimtzum ∷ StepLeaveReshimu ∷ []
