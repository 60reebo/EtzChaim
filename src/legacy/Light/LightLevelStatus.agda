--------------------------------------------------
-- LightLevelStatus (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Light.LightLevelStatus where

-- | LightLevelStatus (סטטוס רמת אור):
-- ייצוג מצבים שונים של עוצמת האור (פעיל, כבוי, מעבר וכו').


data LightLevelStatus : Set where
  noLight   : LightLevelStatus
  someLight : LightLevelStatus

initialLLS : LightLevelStatus
initialLLS = noLight
