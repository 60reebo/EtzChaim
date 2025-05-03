module Hishtalshelut.Domain.LightChain where

open import Data.Nat using (ℕ; pred)
open import Data.Bool using (Bool; true; false)
open import Data.List using (List; _∷_; []; length)
open import Data.Maybe using (Maybe; just; nothing)
open import Data.Sum using (_⊎_; inj₁; inj₂)

open import Hishtalshelut.Domain.Worlds.IgulimYosher using (Sefirah; allSefirot; LightCategory; Nefesh)
open import Hishtalshelut.Domain.Worlds.EinSof using (CircleEinSof; KavEinSof; einsOf; circleOf)

-- | A unified stream of light/vessel with purity parameter
record LightStream : Set where
  constructor mkLS
  field
    einsofCtx : CircleEinSof ⊎ KavEinSof   -- context wrapper for EinSof
    category  : LightCategory             -- נר"ן, וכו'
    active    : Bool                      -- headAttached ∧ tailAttached
    intensity : ℕ                         -- חשיבות עוצמה
    purity    : ℕ                         -- מידת טוהר: גבוה=עדין (אור), נמוך=עבה (כלי)

-- | Initial stream from EinSof for the first Sefirah
initialStream : LightStream
initialStream = mkLS (inj₁ (circleOf einsOf))
                     Nefesh
                     true
                     (length allSefirot)
                     (length allSefirot)

-- | Degrade the purity to represent thicker vessel
degradeStream : LightStream → LightStream
degradeStream ls = mkLS
  (LightStream.einsofCtx ls)
  (LightStream.category ls)
  (LightStream.active ls)
  (LightStream.intensity ls)
  (pred (LightStream.purity ls))

-- | Vessel classification: internal vs external tool
data VesselKind : Set where
  InnerVessel : VesselKind
  OuterVessel : VesselKind

-- | A vessel unit with its own internal and surrounding lights
record StreamUnit : Set where
  constructor mkUnit
  field
    seph       : Sefirah        -- which Sefirah
    kind       : VesselKind     -- internal or external vessel
    innerLight : LightStream    -- inner light within this vessel
    outerLight : LightStream    -- surrounding light around this vessel

-- | Build full chain: for each Sefirah produce internal and external vessel units
buildChain : LightStream → List Sefirah → List StreamUnit
buildChain init ss = go init ss where
  go : LightStream → List Sefirah → List StreamUnit
  go _    []       = []
  go prev (s ∷ xs) =
    let innerV       = prev
        innerOut     = degradeStream innerV
        outerV       = degradeStream prev
        outerOut     = degradeStream outerV
        innerUnit    = mkUnit s InnerVessel innerV innerOut
        outerUnit    = mkUnit s OuterVessel outerV outerOut
        nextStream   = outerOut
    in innerUnit ∷ outerUnit ∷ go nextStream xs
