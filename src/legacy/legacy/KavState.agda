--------------------------------------------------
-- KavState (State Layer)
--------------------------------------------------
module Hishtalshelut.State.Worlds.KavState where

open import Hishtalshelut.State.Worlds.ChallalState using (ChallalState)
open import Hishtalshelut.Domain.Worlds.Kav using (Kav)
open import Agda.Builtin.Bool

-- | מצב הקו: האם התחיל, האם עובר במרכז, האם מחלק לאיגולים/יושר
record KavState : Set where
  field
    challalState : ChallalState
    kav          : Kav
    entered      : Bool
    throughCenter : Bool
    splitted     : Bool

-- | מצב ראשוני: קו טרם נכנס
initialKavState : ChallalState → KavState
initialKavState ch = record { challalState = ch ; kav = record { start = 0 ; length = 0 ; direction = 0 } ; entered = false ; throughCenter = false ; splitted = false }
