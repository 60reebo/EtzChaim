module Hishtalshelut.Runtime.StartSteps where

open import Hishtalshelut.State.Worlds.EinSofState public using (EinSofState; initialEinSofState)
open import Hishtalshelut.Rules.Tzimtzum.Tzimtzum public using (PostTzimtzumState; tzimtzum; drawKav)
open import Hishtalshelut.State.Worlds.KavState public using (KavState)
open import Hishtalshelut.Rules.Emanation.AdamKadmon public using (AdamKadmonState; formAdamKadmon)
open import Hishtalshelut.Rules.Emanation.Eynayim public using (NekudimStartState; processEynayimEmanation)
open import Data.Product public using (_×_; _,_; proj₁; proj₂)
open import Data.List using (List; [])
open import Data.String using (String)
open import Data.Nat using (ℕ)

-- | simulate the first three steps and return all states
simulateStartSteps : EinSofState × PostTzimtzumState × KavState × AdamKadmonState × NekudimStartState
simulateStartSteps =
  let einsof    = initialEinSofState
      tzim      = tzimtzum einsof
      kav       = drawKav tzim
      ak        = formAdamKadmon kav
      nekStart  = processEynayimEmanation ak
  in einsof , tzim , kav , ak , nekStart

-- examples: inspect each step separately
exampleEinSof    = proj₁ simulateStartSteps
exampleTzimtzum  = proj₁ (proj₂ simulateStartSteps)
exampleKav       = proj₁ (proj₂ (proj₂ simulateStartSteps))
exampleAdamKadmon = proj₂ (proj₂ (proj₂ simulateStartSteps))
exampleNekudimStart = proj₂ (proj₂ (proj₂ (proj₂ simulateStartSteps)))
