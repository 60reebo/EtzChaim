{-# OPTIONS --without-K #-}
--------------------------------------------------
-- EinSofState (State Layer)
--------------------------------------------------
module Hishtalshelut.State.Worlds.EinSofState where

open import Hishtalshelut.Domain.Worlds.EinSof public using (EinSof; einsOf)
open import Agda.Builtin.Bool
open import Agda.Builtin.Unit

-- | מצב דינמי של אין-סוף: האם מלא באור?
-- Changed from record to data
data EinSofState : Set where
  MkEinSofState : (einSof : EinSof) → (isFullOfLight : Bool) → EinSofState

-- Remove the FOREIGN pragma as Haskell doesn't seem to need this type directly via FFI
-- {-# FOREIGN GHC type AgdaEinSofState #-} 

-- מצב ראשוני: הכל מלא אור
initialEinSofState : EinSofState
initialEinSofState = MkEinSofState einsOf true
