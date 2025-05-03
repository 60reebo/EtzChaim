--------------------------------------------------
-- IgulimYosherScenario (Runtime/Scenario Layer)
--------------------------------------------------
{-# OPTIONS --guardedness --no-termination-check #-}
module Hishtalshelut.Runtime.Worlds.IgulimYosherScenario where

open import Hishtalshelut.Engine.Worlds.IgulimYosherEngine using (simulateFullIgulimYosher)
open import Hishtalshelut.State.Worlds.IgulimYosherFullState using (IgulimYosherFullState)

-- | תרחיש הרצה: סימולציה מלאה של יצירת עיגולים ויושר עד סוף ההתפשטות (כל החלל מלא)
runScenarioFullIgulimYosher : IgulimYosherFullState
runScenarioFullIgulimYosher = simulateFullIgulimYosher
