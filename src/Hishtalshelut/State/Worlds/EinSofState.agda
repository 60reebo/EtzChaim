--------------------------------------------------
-- EinSofState (State Layer)
--------------------------------------------------
module Hishtalshelut.State.Worlds.EinSofState where

open import Hishtalshelut.Domain.Worlds.EinSof public using (EinSof; einsOf)
open import Agda.Builtin.Bool
open import Agda.Builtin.Unit

-- | מצב דינמי של אין-סוף: האם מלא באור?
record EinSofState : Set where
  field
    einSof        : EinSof
    isFullOfLight : Bool

-- מצב ראשוני: הכל מלא אור
initialEinSofState : EinSofState
initialEinSofState = record { einSof = einsOf ; isFullOfLight = true }
