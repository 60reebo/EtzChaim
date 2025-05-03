--------------------------------------------------
-- SefirahStateInPartzuf (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Sefirah.SefirahStateInPartzuf where

open import Hishtalshelut.Domain.Light.LightLevelStatus public
open import Data.Bool public

record SefirahStateInPartzuf : Set where
  field
    lightStatus : LightLevelStatus
    isActive    : Bool
    -- ניתן להוסיף שדות נוספים בהמשך (למשל kelimStatus)
