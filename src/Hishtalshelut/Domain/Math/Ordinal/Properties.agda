{-# OPTIONS --without-K #-}
--------------------------------------------------
-- Ordinal Properties (Domain/Math)
--------------------------------------------------
module Hishtalshelut.Domain.Math.Ordinal.Properties where

open import Agda.Primitive using (Level)
open import Data.Bool using (Bool; true; false; if_then_else_)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)

open import Hishtalshelut.Domain.Math.Ordinal

-- | האם אורדינל אחד גדול או שווה לאחר
-- | מממש פונקציה בוליאנית
ordStronger : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ → Bool
ordStronger zero zero = true
ordStronger zero (succ _) = false
ordStronger zero (limit _) = false
ordStronger (succ a) zero = true 
ordStronger (succ a) (succ b) = ordStronger a b
ordStronger (succ _) (limit _) = false  -- צריך לדון במקרה זה
ordStronger (limit _) zero = true
ordStronger (limit _) (succ _) = true   -- צריך לדון במקרה זה
ordStronger (limit f) (limit g) = false -- מקרה מורכב, דורש דיון מעמיק

-- | בדיקה אם אורדינל אחד קטן-שווה לאחר
-- | מוגדר במונחי ordStronger
-- אנחנו משתמשים ב-ordLeq מהמודול הראשי
open import Hishtalshelut.Domain.Math.Ordinal using (ordLeq)

-- אליאס למיגרציה הדרגתית
stronger = ordStronger 