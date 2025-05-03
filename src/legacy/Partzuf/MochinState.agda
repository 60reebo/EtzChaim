--------------------------------------------------
-- MochinState (State Layer)
--------------------------------------------------
module Hishtalshelut.State.Partzuf.MochinState where

-- | MochinLevel: קטנות, גדלות א', גדלות ב'
data MochinLevel : Set where
  Katnut  : MochinLevel
  Gadlut1 : MochinLevel
  Gadlut2 : MochinLevel

-- | MochinState: מצב המוחין של פרצוף
record MochinState : Set where
  field
    level : MochinLevel

-- | מצב מוחין התחלתי (קטנות)
initialMochin_Katnut : MochinState
initialMochin_Katnut = record { level = Katnut }
