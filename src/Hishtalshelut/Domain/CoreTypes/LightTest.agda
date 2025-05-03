--------------------------------------------------
-- Light Test (Domain/CoreTypes)
--------------------------------------------------
module Hishtalshelut.Domain.CoreTypes.LightTest where

open import Agda.Primitive using (Level; lzero)
open import Data.Bool using (Bool; true; false; _∧_; _∨_)
open import Data.Nat using (ℕ; zero; suc)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)

open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; fin; aleph)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; limit; fromNatO; omega)
open import Hishtalshelut.Domain.Worlds.IgulimYosher lzero using (LightCategory; Nefesh; Ruach; LightKind; Pnimi; Makif)
open import Hishtalshelut.Domain.CoreTypes.Light lzero

-- | אורות לדוגמה עבור בדיקת המיזוג
lightA : Light
lightA = mkLight (fin 5) (succ (succ zero)) Nefesh Pnimi "SourceA" (fromNatO 1)

lightB : Light
lightB = mkLight (fin 3) (succ zero) Nefesh Pnimi "SourceB" (fromNatO 2) 

lightC : Light
lightC = mkLight (aleph zero) omega Ruach Makif "SourceC" (fromNatO 3)

-- | בדיקת מיזוג רגיל (מקסימום)
testMergeRegular : Bool
testMergeRegular = 
  let merged = mergeLight lightA lightB false
  in  power merged ≡ fin 8 ∧  -- 5 + 3 = 8
      structure merged ≡ succ (succ zero)  -- max(succ(succ(zero)), succ(zero)) = succ(succ(zero))

-- | בדיקת מיזוג מעמיק (חיבור)
testMergeDeep : Bool
testMergeDeep = 
  let merged = mergeLight lightA lightB true
  in  power merged ≡ fin 8 ∧  -- 5 + 3 = 8
      structure merged ≡ succ (succ (succ zero))  -- succ(succ(zero)) + succ(zero) = succ(succ(succ(zero)))

-- | בדיקת מיזוג עם אור טרנספיניטי
testMergeTransfinite : Bool
testMergeTransfinite =
  let merged = mergeLight lightA lightC false
  in  power merged ≡ aleph zero  -- fin(5) + aleph0 = aleph0
      
-- | בדיקת פונקציית השוואת האור
testIsStronger : Bool
testIsStronger =
  (isStrongerLight lightA lightB ≡ true) ∧  -- lightA חזק יותר מ-lightB
  (isStrongerLight lightB lightA ≡ false) ∧ -- lightB לא חזק יותר מ-lightA
  (isStrongerLight lightC lightA ≡ true)    -- lightC חזק יותר מ-lightA 