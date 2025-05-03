--------------------------------------------------
-- SefirahStateInPartzuf (State Layer)
--------------------------------------------------
module Hishtalshelut.State.Partzuf.SefirahStateInPartzuf where

open import Hishtalshelut.Domain.Light.LightLevelStatus public
open import Data.Bool public
open import Data.Maybe
open import Data.Unit.Base using (⊤; tt)

record SefirahStateInPartzuf : Set where
  field
    lightStatus : LightLevelStatus   -- מצב האור בספירה (פעיל/כבויה/מעבר)
    isActive    : Bool               -- האם הספירה פעילה בפרצוף זה
    kelimStatus : Maybe ⊤            -- מצב הכלי (placeholder, specialization per world in Rules layer)
    -- אפשר להוסיף שדות נוספים: רמת מוחין, האם מקבלת אור מקיף, ועוד
