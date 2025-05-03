{-# OPTIONS --without-K --no-main #-}
--------------------------------------------------
-- Rules/Light/TzelemTransformations
--------------------------------------------------
module Hishtalshelut.Rules.Light.TzelemTransformations (ℓ : Agda.Primitive.Level) where

open import Agda.Primitive using (Level; lsuc)
open import Data.Bool using (Bool; true; false; _∧_; _∨_; if_then_else_)
open import Data.List using (List; _∷_; []; map; foldr; filter)
open import Data.Bool.ListAction using (any)
open import Data.Nat using (ℕ) renaming (_+_ to _+ℕ_; _*_ to _*ℕ_; _^_ to _^ℕ_; _>_ to _>ℕ_; _≥_ to _≥ℕ_)
open import Data.String using (String; _++_)
open import Data.Maybe using (Maybe; just; nothing; maybe′)
open import Data.Product using (_×_; _,_; proj₁; proj₂)
open import Function using (_∘_; id)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)

-- ייבוא הטיפוסים ופונקציות מהמודולים הקיימים
open import Hishtalshelut.State.Light.KeliState ℓ using (KeliState; kelim; updateKelim)
open import Hishtalshelut.State.Worlds.IgulimYosherFullState ℓ using (IgulimYosherFullState; keliState)
open import Hishtalshelut.Domain.CoreTypes.Keli ℓ using (Keli; mkKeli; content; label; state; substance; capacity; seph; kind; tzelem_letters; updateKeliContent; updateKeliState)
                                            renaming (KeliState to KeliCondition)
open import Hishtalshelut.Domain.CoreTypes.Light ℓ using (Light; mkLight; power; structure; category; kind; source; timestamp; tzelem_letter; mergeLight; TzelemLetter; Tzadi; Lamed; Mem)
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; _⊕_; fin; aleph)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; limit; _+_)

--------------------------------------------------
-- פונקציות עזר לעבודה עם הטיפוסים הקיימים
--------------------------------------------------

-- | עדכון רשימת אותיות הצלם בכלי
updateTzelemLetters : List TzelemLetter → Keli → Keli
updateTzelemLetters newLetters keli = record keli { tzelem_letters = newLetters }

-- | קבלת האורות מכלי (יצירת גישה מכיוון שאינה קיימת ב-Keli הקיים)
lights : Keli → List Light
lights keli = content keli ∷ []  -- מחזיר רשימה שמכילה את האור הנוכחי של הכלי

-- | עדכון האורות בכלי
updateLights : List Light → Keli → Keli
updateLights [] keli = keli  -- אין אורות לעדכון
updateLights (l ∷ _) keli = updateKeliContent keli l  -- מעדכן את האור הראשון ברשימה

-- | עדכון מבנה הכלי (מאחר ואין שדה ישיר למבנה, אשתמש באור הפנימי)
updateStructure : Ordinal ℓ → Keli → Keli
updateStructure newStructure keli = 
  let oldLight = content keli
      newLight = record oldLight { structure = newStructure }
  in updateKeliContent keli newLight

-- | פונקציית עזר - בדיקת שוויון בין אותיות צלם
eqTzelem : TzelemLetter → TzelemLetter → Bool
eqTzelem Tzadi Tzadi = true
eqTzelem Lamed Lamed = true
eqTzelem Mem Mem = true
eqTzelem _ _ = false

-- | שלילה לוגית
not : Bool → Bool
not true = false
not false = true

-- | העברת תהליך אותיות צל"ם על כלי אחד
applyTzelemToKeli : Keli → Keli
applyTzelemToKeli keli = 
  let 
    hasTzadi = any (λ letter → eqTzelem letter Tzadi) (tzelem_letters keli)
    hasLamed = any (λ letter → eqTzelem letter Lamed) (tzelem_letters keli)
    hasMem = any (λ letter → eqTzelem letter Mem) (tzelem_letters keli)
    
    -- עדכון האור לפי אותיות צל"ם הקיימות
    currentLight = content keli
    
    -- צ' - הגברת עוצמה
    lightAfterTzadi = 
      if hasTzadi 
      then record currentLight { power = power currentLight ⊕ (fin 10) }
      else currentLight
    
    -- ל' - העמקת מבנה
    lightAfterLamed = 
      if hasLamed 
      then record lightAfterTzadi { structure = structure lightAfterTzadi + (succ zero) }
      else lightAfterTzadi
    
    -- ם' - הגברת עוצמה ומבנה
    lightAfterMem = 
      if hasMem 
      then record lightAfterLamed { 
          power = power lightAfterLamed ⊕ (fin 5)
        ; structure = structure lightAfterLamed + (succ zero)
        ; source = source lightAfterLamed ++ "+mem_transformation"
        }
      else lightAfterLamed
    
    -- עדכון הכלי עם האור החדש
    updatedKeli = updateKeliContent keli lightAfterMem
  in 
    updatedKeli

-- | עדכון מצב כל הכלים על ידי יישום טרנספורמציות צל"ם
applyTzelemTransformations : IgulimYosherFullState → IgulimYosherFullState
applyTzelemTransformations state =
  let
    ks = keliState state
    updatedKelim = map applyTzelemToKeli (kelim ks)
    updatedKeliState = updateKelim updatedKelim ks
  in
    record state { keliState = updatedKeliState }