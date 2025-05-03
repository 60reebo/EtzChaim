--------------------------------------------------
-- EinSofScenario (Runtime/Scenario Layer)
--------------------------------------------------
module Hishtalshelut.Runtime.Worlds.EinSofScenario where

open import Hishtalshelut.Engine.Worlds.EinSofEngine using (runEinSofFullLight)
open import Hishtalshelut.State.Worlds.EinSofState using (EinSofState)
open import Agda.Builtin.Unit public using (⊤; tt)

-- | תרחיש הרצה: יצירת אין-סוף מלא אור ובדיקה
runScenarioEinSofFull : EinSofState
runScenarioEinSofFull = runEinSofFullLight tt
