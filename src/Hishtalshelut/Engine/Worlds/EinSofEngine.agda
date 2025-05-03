--------------------------------------------------
-- EinSofEngine (Engine Layer)
--------------------------------------------------
module Hishtalshelut.Engine.Worlds.EinSofEngine where

open import Hishtalshelut.Rules.Worlds.EinSofRules using (startWithFullEinSof)
open import Hishtalshelut.State.Worlds.EinSofState using (EinSofState)
open import Agda.Builtin.Unit public using (⊤; tt)

-- | מנוע סימולציה: התחלת אין-סוף מלא אור
runEinSofFullLight : ⊤ → EinSofState
runEinSofFullLight = startWithFullEinSof
