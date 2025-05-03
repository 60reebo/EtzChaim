module Hishtalshelut.Engine.Simulation where

-- Imports
open import Agda.Primitive public
open import Hishtalshelut.Domain.All public
open import Hishtalshelut.State.Olam.Atzilut public using (OlamAtzilutState; stepAtzilutCycle; initialAtzilutState_refined)
open import Hishtalshelut.State.Olam.BYA public
open import Data.Maybe using (Maybe; maybe)
open import Data.Product using (_×_)

-- World State (as before)
record WorldState : Set where
  constructor mkWorldState
  field
    atzilutState  : OlamAtzilutState
    masach        : Masach
    byaState      : OlamBYAState
    availableMN   : MayinNukvin
    tikkunEffort  : TikkunEffort

-- Initial World State
initialWorldState : WorldState
initialWorldState = mkWorldState initialAtzilutState_refined initialMasach initialBYAState 0 1

-- Main Simulation Step Function
stepWorld : WorldState -> WorldState
stepWorld currentWorldState =
  let atzState   = currentWorldState .WorldState.atzilutState
      masach     = currentWorldState .WorldState.masach
      byaState₀  = currentWorldState .WorldState.byaState
      mn         = currentWorldState .WorldState.availableMN
      effort     = currentWorldState .WorldState.tikkunEffort
      -- Run Atzilut Cycle
      (nextAtzState , maybeShefa) = stepAtzilutCycle atzState mn
      -- Flow Shefa through BYA
      byaState₁  = maybe byaState₀ (λ s → flowShefaToBeriah s masach byaState₀) maybeShefa
      byaState₂  = flowShefaBeriahToYetzirah byaState₁
      byaState₃  = flowShefaYetzirahToAssiah byaState₂
      -- Internal BYA updates
      finalBYAState = updateBYAInternal byaState₃ effort
      -- Generate next MN
      nextMN = generateMN finalBYAState effort
  in mkWorldState nextAtzState masach finalBYAState nextMN effort
