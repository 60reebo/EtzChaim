module Hishtalshelut.Domain.Rashash.Names.BodyPart where

open import Relation.Binary.PropositionalEquality using (_≡_)
open import Data.Bool using (Bool; true; false)

-- | Main body parts mapping
data BodyPart : Set where
  Head     : BodyPart
  RightArm : BodyPart
  LeftArm  : BodyPart
  Heart    : BodyPart
  Liver    : BodyPart
  RightLeg : BodyPart
  LeftLeg  : BodyPart
  Torso    : BodyPart

-- | Boolean equality for body parts
_≟BodyPart_ : BodyPart → BodyPart → Bool
Head     ≟BodyPart Head     = true
RightArm ≟BodyPart RightArm = true
LeftArm  ≟BodyPart LeftArm  = true
Heart    ≟BodyPart Heart    = true
Liver    ≟BodyPart Liver    = true
RightLeg ≟BodyPart RightLeg = true
LeftLeg  ≟BodyPart LeftLeg  = true
Torso    ≟BodyPart Torso    = true
_      ≟BodyPart _         = false
