--------------------------------------------------
-- EinSofRules (Rules Layer)
--------------------------------------------------
module Hishtalshelut.Rules.Worlds.EinSofRules where

open import Hishtalshelut.Domain.Worlds.EinSof using (EinSof)
open import Hishtalshelut.State.Worlds.EinSofState using (EinSofState ; initialEinSofState)
open import Agda.Builtin.Unit

-- | יצירת מצב ראשוני של אין-סוף מלא אור
startWithFullEinSof : Unit → EinSofState
startWithFullEinSof _ = initialEinSofState
