--------------------------------------------------
-- Light Transformations (Rules Layer)
--------------------------------------------------
module Hishtalshelut.Rules.Light.LightTransformations where

open import Agda.Primitive using (Level; lzero)
open import Data.Bool using (Bool; true; false; if_then_else_; _∧_)
open import Data.List using (List; _∷_; []; map; foldr; filter; zip; zipWith)
open import Data.Maybe using (Maybe; just; nothing)
open import Data.Nat using (ℕ; zero; suc)
open import Data.Nat.Base using (_⊓_)
open import Data.String.Base using (_++_)
open import Data.Product using (_×_; _,_)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)

open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; fin; aleph; _⊕_; _⊗_; predC)
open import Hishtalshelut.Domain.Math.Cardinal.Properties as CardProps using (cardStronger)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; maxO; predO; zero; succ; limit; _+_; _*_)
open import Hishtalshelut.Domain.CoreTypes.Light lzero
open import Hishtalshelut.Domain.CoreTypes.Keli lzero
open import Hishtalshelut.Domain.LightChain lzero using (degradeLight)

-- | מיזוג אורות מרובים בתוך כלי
-- | כאשר יש מספר אורות בכלי, ממזגים אותם לאור אחד
mergeAllLightsInKeli : Keli → Keli
mergeAllLightsInKeli k = k  -- ממומש רק כאשר יש רשימת אורות בכלי

-- | מיזוג אור בין שני כלים שכנים
-- | האור הממוזג נכנס לכלי השני
mergeAdjacentKelim : Keli → Keli → Bool → (Keli × Keli)
mergeAdjacentKelim k₁ k₂ deepMerge =
  let mergedLight = mergeLight (content k₁) (content k₂) deepMerge
      k₁' = updateKeliContent k₁ (degradeLight (content k₁))  -- מפחית את עוצמת האור בכלי הראשון
      k₂' = updateKeliContent k₂ mergedLight  -- מעדכן את הכלי השני עם האור הממוזג
  in (k₁' , k₂')

-- | מעביר אור בין כלים על פי כיוון הזרימה
-- | deepFlow מציין האם להשתמש בחיבור מעמיק של האורדינלים
flowLight : Keli → Keli → Bool → (Keli × Keli)
flowLight source target deepFlow =
  let sourceLight = content source
      targetLight = content target
      -- חישוב עוצמת האור שיעבור
      transferAmount = 
        if CardProps.cardStronger (power sourceLight) (fin 10)
        then power sourceLight  -- אם האור מספיק חזק, העבר הכל
        else predC (power sourceLight)  -- אחרת, העבר חלק מהאור
      
      -- יצירת האור המועבר
      transferredLight = mkLight 
        transferAmount
        (structure sourceLight)
        (category sourceLight)
        (kind sourceLight)
        (source sourceLight ++ "→" ++ source targetLight)
        (timestamp sourceLight)
      
      -- האור שנשאר במקור
      remainingLight = mkLight
        (fin 1)  -- משאיר מעט אור במקור
        (predO (structure sourceLight))  -- מפחית את המבנה
        (category sourceLight)
        (kind sourceLight)
        (source sourceLight)
        (timestamp sourceLight)
      
      -- האור הממוזג ביעד
      mergedLight = mergeLight transferredLight targetLight deepFlow
      
      -- עדכון הכלים
      source' = updateKeliContent source remainingLight
      target' = updateKeliContent target mergedLight
  in (source' , target')

-- | שבירת כלי כאשר האור חזק מדי
breakKeli : Keli → List Light
breakKeli k =
  if CardProps.cardStronger (power (content k)) (capacity k)
  then 
    let fragmented = fragmentLight (content k) 5  -- מפצל את האור ל-5 אורות חלשים יותר
    in filter (λ l → CardProps.cardStronger (power l) (fin 0)) fragmented  -- מסיר אורות ללא עוצמה
  else [ content k ]  -- אם האור לא חזק מדי, החזר אותו כמו שהוא
  where
    -- מפצל אור אחד למספר אורות חלשים יותר
    fragmentLight : Light → ℕ → List Light
    fragmentLight _ zero = []
    fragmentLight l (suc n) = 
      let dividedPower = divide (power l) 5  -- מחלק את העוצמה ב-5
          weakerLight = mkLight 
            dividedPower 
            (predO (structure l))  -- מפחית את המבנה
            (category l)
            (kind l)
            (source l ++ "-fragment")
            (timestamp l)
      in weakerLight ∷ fragmentLight l n
    
    -- מחלק עוצמת אור (קרדינל) במספר נתון
    divide : ∀ {ℓ} → Cardinal ℓ → ℕ → Cardinal ℓ
    divide (fin n) m = fin (n ⊓ m)  -- מחזיר את המינימום בין n ל-m
    divide (aleph α) _ = aleph α  -- אינסוף נשאר אינסוף גם אחרי חלוקה 