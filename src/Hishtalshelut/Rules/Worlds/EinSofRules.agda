-- EinSofRules (Rules Layer)
--------------------------------------------------
module Hishtalshelut.Rules.Worlds.EinSofRules where

open import Agda.Builtin.Unit public using (⊤; tt)
open import Hishtalshelut.Domain.Worlds.EinSof using (EinSof)
open import Hishtalshelut.State.Worlds.EinSofState using (EinSofState ; initialEinSofState)

-- | יצירת מצב ראשוני של אין-סוף מלא אור
startWithFullEinSof : ⊤ → EinSofState
startWithFullEinSof _ = initialEinSofState
