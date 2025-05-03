{-# OPTIONS --without-K #-}
--------------------------------------------------
-- Cardinal Properties (Domain/Math)
--------------------------------------------------
module Hishtalshelut.Domain.Math.Cardinal.Properties where

open import Agda.Primitive using (Level)
open import Data.Bool using (Bool; true; false; if_then_else_)
open import Data.Nat using (ℕ; _≤_; zero; suc)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)

open import Hishtalshelut.Domain.Math.Cardinal
open import Hishtalshelut.Domain.Math.Ordinal.Properties as OrdProps using (ordStronger)

-- | האם קרדינל אחד גדול או שווה לאחר
-- | לוגיקה:
-- | 1. אלף כלשהו תמיד גדול מ-fin כלשהו
-- | 2. אם שניהם fin, ההשוואה היא על המספרים הטבעיים
-- | 3. אם שניהם aleph, ההשוואה היא על האורדינלים שלהם
cardStronger : ∀ {ℓ} → Cardinal ℓ → Cardinal ℓ → Bool
cardStronger (fin m) (fin n) = natLeq n m  -- הפוך כי אנחנו רוצים m ≥ n
  where
    natLeq : ℕ → ℕ → Bool
    natLeq zero zero = true
    natLeq zero (suc _) = true
    natLeq (suc _) zero = false
    natLeq (suc m) (suc n) = natLeq m n
    
cardStronger (fin _) (aleph _) = false  -- aleph תמיד גדול מ-fin
cardStronger (aleph _) (fin _) = true   -- aleph תמיד גדול מ-fin
cardStronger (aleph α) (aleph β) = OrdProps.ordStronger α β  -- משתמש בהשוואת אורדינלים

-- אליאס למיגרציה הדרגתית
stronger = cardStronger 