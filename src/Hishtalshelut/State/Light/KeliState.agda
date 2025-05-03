{-# OPTIONS --without-K --no-main #-}
--------------------------------------------------
-- State/Light/KeliState
--------------------------------------------------
module Hishtalshelut.State.Light.KeliState (ℓ : Agda.Primitive.Level) where

open import Agda.Primitive using (Level; lsuc)
open import Data.List using (List; _∷_; []; map; foldr)
open import Data.Bool using (Bool; true; false; if_then_else_; _∧_)
open import Data.Maybe using (Maybe; just; nothing)
open import Data.Nat using (ℕ)
open import Data.String using (String)
open import Agda.Builtin.String using (primStringEquality)

-- ייבוא הטיפוסים מהמודולים הקיימים ושימוש סלקטיבי 
-- כדי להימנע מהתנגשות ב-KeliState
open import Hishtalshelut.Domain.CoreTypes.Keli ℓ using (Keli; label; content; updateKeliContent)
open import Hishtalshelut.Domain.CoreTypes.Light ℓ
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal)

-- שימוש בטיפוס מצב הכלי המקורי תחת שם שונה
open import Hishtalshelut.Domain.CoreTypes.Keli ℓ using () renaming (KeliState to KeliCondition)

-- | מצב הכלים במערכת - אוסף של כלים
record KeliState : Set (lsuc ℓ) where
  constructor mkKeliState
  field
    kelim : List Keli
open KeliState public

-- | פונקציה לעדכון רשימת הכלים
updateKelim : List Keli → KeliState → KeliState
updateKelim newKelim state = record state { kelim = newKelim }

-- | פונקציה למציאת כלי לפי התווית שלו
findKeliByLabel : String → KeliState → Maybe Keli
findKeliByLabel _ (mkKeliState []) = nothing
findKeliByLabel targetLabel (mkKeliState (k ∷ ks)) =
  if label k == targetLabel
  then just k
  else findKeliByLabel targetLabel (mkKeliState ks)
  where 
    _==_ : String → String → Bool
    _==_ = primStringEquality

-- | מצב התחלתי של כלים - רשימה ריקה
initialKeliState : KeliState
initialKeliState = mkKeliState [] 