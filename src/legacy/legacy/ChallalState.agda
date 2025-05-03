--------------------------------------------------
-- ChallalState (State Layer)
--------------------------------------------------
module Hishtalshelut.State.Worlds.ChallalState where

open import Hishtalshelut.State.Worlds.ReshimuState using (ReshimuState)
open import Agda.Builtin.Bool

-- | מצב החלל הריק לאחר הצמצום
record ChallalState : Set where
  field
    reshimuState : ReshimuState
    isEmpty      : Bool

-- | מצב ראשוני: חלל ריק
initialChallalState : ReshimuState → ChallalState
initialChallalState rs = record { reshimuState = rs ; isEmpty = true }
