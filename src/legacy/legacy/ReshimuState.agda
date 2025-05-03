--------------------------------------------------
-- ReshimuState (State Layer)
--------------------------------------------------
module Hishtalshelut.State.Worlds.ReshimuState where

open import Hishtalshelut.Domain.Worlds.Tzimtzum using (ReshimuLevel)
open import Hishtalshelut.State.Worlds.TzimtzumState using (TzimtzumState)

-- | מצב הרשימו: רושם דק של אור לאחר צמצום
record ReshimuState : Set where
  field
    tzimtzumState : TzimtzumState
    reshimu       : ReshimuLevel

-- | מצב ראשוני: אין רשימו
initialReshimuState : TzimtzumState → ReshimuState
initialReshimuState ts = record { tzimtzumState = ts ; reshimu = ReshimuLevel.NoReshimu }

-- | מצב אחרי צמצום: יש רשימו
afterTzimtzumReshimuState : TzimtzumState → ReshimuState
afterTzimtzumReshimuState ts = record { tzimtzumState = ts ; reshimu = ReshimuLevel.WithReshimu }
