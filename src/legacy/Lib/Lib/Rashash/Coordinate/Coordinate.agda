module Hishtalshelut.Domain.Rashash.Coordinate.Coordinate where

-- | Rashash coordinate in 7D context
open import Data.Nat using (ℕ)
open import Data.Vec.Base using (Vec; []; _∷_)
open import Relation.Binary.PropositionalEquality using (_≡_)

open import Hishtalshelut.Domain.Rashash.Names.World using (OlamName; EinSof; Atzilut; Beriah; Yetzirah; Asiyah; _≟Olam_)
open import Hishtalshelut.Domain.Rashash.Names.Partzuf using (Partzuf; AA; Abba; Ima; ZA; Nukva; _≟Partzuf_)
open import Hishtalshelut.Domain.Rashash.Names.BodyPart using (BodyPart; Head; RightArm; LeftArm; Heart; Liver; RightLeg; LeftLeg; Torso; _≟BodyPart_)
open import Hishtalshelut.Domain.Rashash.Names.Sefirah using (SefirahName; Keter; Chochmah; Binah; Chesed; Gevurah; Tiferet; Netzach; Hod; Yesod; Malchut; _≟Sefirah_)
open import Hishtalshelut.Domain.Rashash.Names.ShemOhr using (ShemOhr; AB_SAG; _≟ShemOhr_; mainShem)

-- | Coordinate of an entity in Rashash system
record RashashCoordinate : Set where
  constructor mkRashashCoord
  field
    igul     : ℕ                -- ציר X: עיגול
    yosher   : ℕ                -- ציר Y: יושר
    olam     : OlamName         -- עולם
    partzuf  : Partzuf          -- פרצוף
    bodyPart : BodyPart         -- איבר
    depth    : Vec SefirahName 10 -- עומק פנימי
    shemOhr  : ShemOhr          -- שם אור

open RashashCoordinate

-- removed boolean imports, using propositional equality only

-- | Propositional equality for coordinates
_≟RashashCoord_ : RashashCoordinate -> RashashCoordinate -> Set
c₁ ≟RashashCoord c₂ = c₁ ≡ c₂

-- | Example coordinate
exampleRashashCoord : RashashCoordinate
exampleRashashCoord = mkRashashCoord 3 1 Beriah Abba RightArm
  (Keter ∷ Chochmah ∷ Binah ∷ Chesed ∷ Gevurah ∷ Tiferet ∷ Netzach ∷ Hod ∷ Yesod ∷ Malchut ∷ [])
  AB_SAG
