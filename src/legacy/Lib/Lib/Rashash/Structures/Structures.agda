module Hishtalshelut.Domain.Rashash.Structures.Structures where

-- | Recursive layered structures and utility functions
open import Data.Nat using (ℕ; zero; suc)
open import Data.List using (List; _∷_; [])
open import Data.Maybe using (Maybe; just; nothing)

open import Hishtalshelut.Domain.Rashash.Names.World using (OlamName)
open import Hishtalshelut.Domain.Rashash.Names.Partzuf using (Partzuf)
open import Hishtalshelut.Domain.Rashash.Names.BodyPart using (BodyPart)
open import Hishtalshelut.Domain.Rashash.Names.Sefirah using (SefirahName)
open import Hishtalshelut.Domain.Rashash.Names.ShemOhr using (ShemOhr)

-- | Layered world with inner sub-worlds (מלבושים)
data OlamLayered : Set where
  mkOlamLayered : OlamName → List OlamLayered → OlamLayered

-- | Layered partzuf tree structure
data PartzufLayered : Set where
  mkPartzufLayered : Partzuf → List PartzufLayered → PartzufLayered

-- | Get layer by index (0-based) or Nothing
getLayer : {A : Set} → List A → ℕ → Maybe A
getLayer [] _        = nothing
getLayer (x ∷ xs) zero = just x
getLayer (_ ∷ xs) (suc n) = getLayer xs n

-- | Corresponding layer (same index) for garments
getCorrespondingLayer : {A : Set} → List A → ℕ → Maybe A
getCorrespondingLayer = getLayer

-- | Full coordinate with dynamic properties
record FullRashashCoordinate : Set where
  field
    igul     : ℕ
    yosher   : ℕ
    olam     : OlamName
    partzuf  : Partzuf
    bodyPart : BodyPart
    depth    : List SefirahName
    shemOhr  : ShemOhr
    nekuda   : Maybe SefirahName
    orLevel  : Maybe ℕ
    kliType  : Maybe ℕ
    status   : Maybe ℕ
