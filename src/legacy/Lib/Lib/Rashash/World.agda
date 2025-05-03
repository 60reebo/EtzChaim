module Hishtalshelut.Domain.Rashash.World where

-- | Basic spiritual world and entity names
open import Data.Nat using (ℕ)
open import Data.List using (List; []; _∷_)
open import Relation.Binary.PropositionalEquality using (_≡_)
open import Data.Bool using (Bool; true; false)

-- | Spiritual worlds hierarchy
data OlamName : Set where
  EinSof   : OlamName
  Atzilut  : OlamName
  Beriah   : OlamName
  Yetzirah : OlamName
  Asiyah   : OlamName

-- | Boolean equality for worlds
_≟Olam_ : OlamName → OlamName → Bool
EinSof   ≟Olam EinSof   = true
Atzilut  ≟Olam Atzilut  = true
Beriah   ≟Olam Beriah   = true
Yetzirah ≟Olam Yetzirah = true
Asiyah   ≟Olam Asiyah   = true
_ ≟Olam _              = false

-- | Names of the ten sefirot
data SefirahName : Set where
  Keter    : SefirahName
  Chochmah : SefirahName
  Binah    : SefirahName
  Chesed   : SefirahName
  Gevurah  : SefirahName
  Tiferet  : SefirahName
  Netzach  : SefirahName
  Hod      : SefirahName
  Yesod    : SefirahName
  Malchut  : SefirahName

-- | Boolean equality for sefirot names
_≟Sefirah_ : SefirahName → SefirahName → Bool
Keter    ≟Sefirah Keter    = true
Chochmah ≟Sefirah Chochmah = true
Binah    ≟Sefirah Binah    = true
Chesed   ≟Sefirah Chesed   = true
Gevurah  ≟Sefirah Gevurah  = true
Tiferet  ≟Sefirah Tiferet  = true
Netzach  ≟Sefirah Netzach  = true
Hod      ≟Sefirah Hod      = true
Yesod    ≟Sefirah Yesod    = true
Malchut  ≟Sefirah Malchut  = true
_ ≟Sefirah _             = false

-- | Partzufim (spiritual configurations)
data Partzuf : Set where
  AA    : Partzuf
  Abba  : Partzuf
  Ima   : Partzuf
  ZA    : Partzuf
  Nukva : Partzuf

-- | Boolean equality for partzufim
_≟Partzuf_ : Partzuf → Partzuf → Bool
AA    ≟Partzuf AA    = true
Abba  ≟Partzuf Abba  = true
Ima   ≟Partzuf Ima   = true
ZA    ≟Partzuf ZA    = true
Nukva ≟Partzuf Nukva = true
_ ≟Partzuf _          = false

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
_ ≟BodyPart _             = false
