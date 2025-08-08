{-# OPTIONS --without-K #-}
--------------------------------------------------
-- TzimtzumState (State Layer)
--------------------------------------------------
open import Agda.Primitive using (Level; lzero; lsuc; _⊔_)
module Hishtalshelut.State.Worlds.TzimtzumState (ℓ : Level) where

open import Hishtalshelut.Domain.Worlds.Tzimtzum ℓ public using (
  TzimtzumStatus; WillForCreation; ReshimuLevel; 
  ContractionStep; NoReshimu; PartialReshimu; CompleteReshimu; 
  TzimtzumSpec; CenterPoint; Midpoint; OrdinalLayer; CircleShape
  )
open import Hishtalshelut.State.Worlds.EinSofState public using (EinSofState; initialEinSofState)
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; fin; aleph)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; limit; omega)
open import Hishtalshelut.Domain.CoreTypes.Light ℓ using (Light)
open import Agda.Builtin.List using (List; []; _∷_)
open import Agda.Builtin.Maybe using (Maybe; just; nothing)
open import Agda.Builtin.Bool public using (Bool; true; false)
open import Agda.Builtin.Nat using (Nat; zero; suc) ; open import Agda.Builtin.Nat renaming (Nat to ℕ)
open import Agda.Builtin.Sigma using (Σ; _,_)
open import Agda.Builtin.String using (String)

infixr 2 _×_
_×_ : ∀ {a b} → Set a → Set b → Set (a ⊔ b)
_×_ A B = Σ A (λ _ → B)

-- Optional helpers
map : ∀ {A B : Set} → (A → B) → List A → List B
map f [] = []
map f (x ∷ xs) = f x ∷ map f xs

filter : ∀ {A : Set} → (A → Bool) → List A → List A
filter p [] = []
filter p (x ∷ xs) with p x
... | true = x ∷ filter p xs
... | false = filter p xs

-- | סוג מפתח עבור שכבות אורדינליות
OrdinalLayerKey = Ordinal ℓ

-- | ניטור שכבות אורדינליות במהלך הצמצום
record OrdinalLayerState : Set (lsuc ℓ) where
  field
    layerMap       : List (OrdinalLayerKey × OrdinalLayer)  -- מיפוי בין מפתח אורדינלי לשכבה
    currentLayer   : Ordinal ℓ                             -- שכבה נוכחית בתהליך
    completedLayers : List (Ordinal ℓ)                     -- שכבות שהושלמו

-- | מצב מאוחד לתהליך הצמצום טרנספיניטי
record ContractionState : Set (lsuc ℓ) where
  field
    einSofState        : EinSofState                       -- מצב אין-סוף
    will               : WillForCreation                   -- רצון לבריאה
    status             : TzimtzumStatus                    -- סטטוס הצמצום
    hasFullLight       : Bool                              -- האם המרחב מלא באור מקורי
    reshimu            : ReshimuLevel                      -- רמת רשימו כללית
    currentRadius      : Ordinal ℓ                         -- רדיוס אורדינלי נוכחי
    maxRadius          : Ordinal ℓ                         -- רדיוס אורדינלי מקסימלי
    spec               : TzimtzumSpec                      -- מפרט הצמצום
    
    -- חדש: מעקב אחר שכבות אורדינליות
    ordinalLayers      : OrdinalLayerState                 -- שכבות אורדינליות
    reshimuByLayer     : List (Ordinal ℓ × Maybe Light)     -- רשימו לפי שכבה
    originalLight      : Light                             -- האור המקורי לפני הצמצום
    emptySpace         : CircleShape                       -- החלל הפנוי שנוצר

open ContractionState public

-- | יצירת שכבת רשימו חדשה
createOrdinalLayer : Ordinal ℓ → OrdinalLayer
createOrdinalLayer ord = record { 
  index = ord ; 
  reshimu = nothing ; 
  isEmpty = false 
  }

-- | אתחול מצב שכבות אורדינליות
initialOrdinalLayerState : OrdinalLayerState
initialOrdinalLayerState = record { 
  layerMap = [] ; 
  currentLayer = zero {ℓ} ; 
  completedLayers = [] 
  }

-- | מצב התחלתי לפני הצמצום: אור מלא
initialContractionState : Light → EinSofState → ContractionState
initialContractionState origLight es = record
  { einSofState = es
  ; will = WillForCreation.NoWill
  ; status = TzimtzumStatus.NoTzimtzum
  ; hasFullLight = true
  ; reshimu = NoReshimu
  ; currentRadius = zero {ℓ}
  ; maxRadius = omega {ℓ} -- אומגה כברירת מחדל לרדיוס מקסימלי
  ; spec = record { 
      center = Midpoint ; 
      maxRadius = omega {ℓ} ;
      lightSource = "EinSof" 
    }
  ; ordinalLayers = initialOrdinalLayerState
  ; reshimuByLayer = []
  ; originalLight = origLight
  ; emptySpace = record { center = Midpoint ; radius = zero {ℓ} }
  }

-- | עדכון מצב הצמצום לאחר צעד אחד
-- | מחזיר מצב עם שכבה אורדינלית חדשה ריקה מאור ומכילה רשימו
afterContractionStep : ContractionState → Ordinal ℓ → ContractionState
afterContractionStep c layerOrd = record c
  { will = WillForCreation.PotentialWill
  ; status = TzimtzumStatus.InProgress
  ; hasFullLight = false
  ; reshimu = PartialReshimu
  ; currentRadius = layerOrd
  ; ordinalLayers = updatedLayers
  ; reshimuByLayer = (layerOrd , nothing) ∷ reshimuByLayer c
  ; emptySpace = record { center = TzimtzumSpec.center (spec c) ; radius = layerOrd }
  }
  where
    newLayer = createOrdinalLayer layerOrd
    updatedLayers = record (ordinalLayers c) 
      { layerMap = (layerOrd , newLayer) ∷ OrdinalLayerState.layerMap (ordinalLayers c)
      ; currentLayer = layerOrd
      }

-- | השלמת הצמצום לאחר השגת רדיוס מקסימלי
-- | מחזיר מצב סופי עם רשימו מלא
completeContraction : ContractionState → ContractionState
completeContraction c = record c
  { status = TzimtzumStatus.AfterTzimtzum
  ; reshimu = CompleteReshimu
  ; ordinalLayers = record (ordinalLayers c) {
      completedLayers = OrdinalLayerState.currentLayer (ordinalLayers c) ∷ OrdinalLayerState.completedLayers (ordinalLayers c)
    }
  }
