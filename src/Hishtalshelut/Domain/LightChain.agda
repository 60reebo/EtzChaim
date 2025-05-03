{-# OPTIONS --without-K #-}
open import Agda.Primitive using (Level) -- Moved before module definition
open import Agda.Primitive using (lsuc) -- Import lsuc specifically

module Hishtalshelut.Domain.LightChain (ℓ : Level) where

open import Data.Bool using (Bool; true; false)
open import Data.List using (List; _∷_; []; length)
open import Data.Maybe using (Maybe; just; nothing)
open import Data.Sum using (_⊎_; inj₁; inj₂)
open import Agda.Builtin.String using (String)
open import Data.Nat using (ℕ; zero; suc) -- Import zero and suc directly
open import Data.Nat.Base as Nat using (pred) -- Use pred instead of _pred

-- Import the parametric module with the current module's level ℓ
open import Hishtalshelut.Domain.Worlds.IgulimYosher ℓ using (Sefirah; allSefirot; LightCategory; Nefesh; Pnimi; Makif) -- Pass ℓ explicitly
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; fin; aleph; fromNat)
open import Hishtalshelut.Domain.Math.Ordinal using (predO; fromNatO)
open import Hishtalshelut.Domain.CoreTypes.Light ℓ using (Light; mkLight)

-- | Predecessor for Cardinals (only affects finite part)
predC : ∀ {ℓ} → Cardinal ℓ → Cardinal ℓ
predC (fin Nat.zero) = fin Nat.zero -- Use Nat.zero from Data.Nat.Base
predC (fin (Nat.suc n)) = fin n -- Use Nat.suc from Data.Nat.Base
predC (aleph α) = aleph α

-- | Initial light from EinSof for the first Sefirah
initialLight : Light
initialLight = mkLight (fromNat (length allSefirot)) (fromNatO (length allSefirot)) Nefesh Pnimi "EinSof" (fromNatO (length allSefirot)) nothing

-- | Degrade the light to represent thicker vessel
degradeLight : Light → Light
degradeLight (mkLight p s c k src ts tzl) = mkLight (predC p) (predO s) c k src ts tzl

-- | Vessel classification: internal vs external tool
data VesselKind : Set where
  InnerVessel : VesselKind
  OuterVessel : VesselKind

-- | A vessel unit with its own internal and surrounding lights
record StreamUnit : Set (lsuc ℓ) where
  constructor mkUnit
  field
    seph       : Sefirah        -- which Sefirah
    kind       : VesselKind     -- internal or external vessel
    innerLight : Light          -- inner light within this vessel
    outerLight : Light          -- surrounding light around this vessel

-- | Build full chain: for each Sefirah produce internal and external vessel units
buildChain : Light → List Sefirah → List StreamUnit
buildChain init ss = go init ss where
  go : Light → List Sefirah → List StreamUnit
  go _ [] = []
  go prev (s ∷ xs) =
    let innerV    = prev
        innerOut  = degradeLight innerV
        outerV    = degradeLight prev
        outerOut  = degradeLight outerV
        innerUnit = mkUnit s InnerVessel innerV innerOut
        outerUnit = mkUnit s OuterVessel outerV outerOut
        next      = outerOut
    in innerUnit ∷ outerUnit ∷ go next xs
