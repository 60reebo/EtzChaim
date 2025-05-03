-- Decidable Equality and Utility Functions
module Hishtalshelut.Lib.EqDec where

open import Agda.Primitive public
open import Relation.Nullary using (Dec; yes; no)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)
open import Agda.Builtin.Nat public using (Nat) -- Needed for some types

-- Import Core types needing equality
open import Data.Empty using (⊥)
open import Hishtalshelut.Domain.All public
open import Hishtalshelut.Domain.General.Orientation public using (Side)
open import Hishtalshelut.State.Olam.BYA.Types public
open import Hishtalshelut.State.Partzuf.MochinState public using (MochinState; MochinLevel; initialMochin_Katnut)
open import Hishtalshelut.State.Partzuf.Base public hiding (_<_)


---------------------------------
-- Decidable Equality Implementations for Core Enums
---------------------------------

-- Sefirah Equality
_s==?_ : (x y : Sefirah) → Dec (x ≡ y)
_s==?_ Keter    Keter    = yes refl
_s==?_ Keter    Chochmah = no (λ ())
_s==?_ Keter    Binah    = no (λ ())
_s==?_ Keter    Daat     = no (λ ())
_s==?_ Keter    Chesed   = no (λ ())
_s==?_ Keter    Gevurah  = no (λ ())
_s==?_ Keter    Tiferet  = no (λ ())
_s==?_ Keter    Netzach  = no (λ ())
_s==?_ Keter    Hod      = no (λ ())
_s==?_ Keter    Yesod    = no (λ ())
_s==?_ Keter    Malchut  = no (λ ())
_s==?_ Chochmah Keter    = no (λ ())
_s==?_ Chochmah Chochmah = yes refl
_s==?_ Chochmah Binah    = no (λ ())
_s==?_ Chochmah Daat     = no (λ ())
_s==?_ Chochmah Chesed   = no (λ ())
_s==?_ Chochmah Gevurah  = no (λ ())
_s==?_ Chochmah Tiferet  = no (λ ())
_s==?_ Chochmah Netzach  = no (λ ())
_s==?_ Chochmah Hod      = no (λ ())
_s==?_ Chochmah Yesod    = no (λ ())
_s==?_ Chochmah Malchut  = no (λ ())
_s==?_ Binah    Keter    = no (λ ())
_s==?_ Binah    Chochmah = no (λ ())
_s==?_ Binah    Binah    = yes refl
_s==?_ Binah    Daat     = no (λ ())
_s==?_ Binah    Chesed   = no (λ ())
_s==?_ Binah    Gevurah  = no (λ ())
_s==?_ Binah    Tiferet  = no (λ ())
_s==?_ Binah    Netzach  = no (λ ())
_s==?_ Binah    Hod      = no (λ ())
_s==?_ Binah    Yesod    = no (λ ())
_s==?_ Binah    Malchut  = no (λ ())
_s==?_ Daat     Keter    = no (λ ())
_s==?_ Daat     Chochmah = no (λ ())
_s==?_ Daat     Binah    = no (λ ())
_s==?_ Daat     Daat     = yes refl
_s==?_ Daat     Chesed   = no (λ ())
_s==?_ Daat     Gevurah  = no (λ ())
_s==?_ Daat     Tiferet  = no (λ ())
_s==?_ Daat     Netzach  = no (λ ())
_s==?_ Daat     Hod      = no (λ ())
_s==?_ Daat     Yesod    = no (λ ())
_s==?_ Daat     Malchut  = no (λ ())
_s==?_ Chesed   Keter    = no (λ ())
_s==?_ Chesed   Chochmah = no (λ ())
_s==?_ Chesed   Binah    = no (λ ())
_s==?_ Chesed   Daat     = no (λ ())
_s==?_ Chesed   Chesed   = yes refl
_s==?_ Chesed   Gevurah  = no (λ ())
_s==?_ Chesed   Tiferet  = no (λ ())
_s==?_ Chesed   Netzach  = no (λ ())
_s==?_ Chesed   Hod      = no (λ ())
_s==?_ Chesed   Yesod    = no (λ ())
_s==?_ Chesed   Malchut  = no (λ ())
_s==?_ Gevurah  Keter    = no (λ ())
_s==?_ Gevurah  Chochmah = no (λ ())
_s==?_ Gevurah  Binah    = no (λ ())
_s==?_ Gevurah  Daat     = no (λ ())
_s==?_ Gevurah  Chesed   = no (λ ())
_s==?_ Gevurah  Gevurah  = yes refl
_s==?_ Gevurah  Tiferet  = no (λ ())
_s==?_ Gevurah  Netzach  = no (λ ())
_s==?_ Gevurah  Hod      = no (λ ())
_s==?_ Gevurah  Yesod    = no (λ ())
_s==?_ Gevurah  Malchut  = no (λ ())
_s==?_ Tiferet  Keter    = no (λ ())
_s==?_ Tiferet  Chochmah = no (λ ())
_s==?_ Tiferet  Binah    = no (λ ())
_s==?_ Tiferet  Daat     = no (λ ())
_s==?_ Tiferet  Chesed   = no (λ ())
_s==?_ Tiferet  Gevurah  = no (λ ())
_s==?_ Tiferet  Tiferet  = yes refl
_s==?_ Tiferet  Netzach  = no (λ ())
_s==?_ Tiferet  Hod      = no (λ ())
_s==?_ Tiferet  Yesod    = no (λ ())
_s==?_ Tiferet  Malchut  = no (λ ())
_s==?_ Netzach  Keter    = no (λ ())
_s==?_ Netzach  Chochmah = no (λ ())
_s==?_ Netzach  Binah    = no (λ ())
_s==?_ Netzach  Daat     = no (λ ())
_s==?_ Netzach  Chesed   = no (λ ())
_s==?_ Netzach  Gevurah  = no (λ ())
_s==?_ Netzach  Tiferet  = no (λ ())
_s==?_ Netzach  Netzach  = yes refl
_s==?_ Netzach  Hod      = no (λ ())
_s==?_ Netzach  Yesod    = no (λ ())
_s==?_ Netzach  Malchut  = no (λ ())
_s==?_ Hod      Keter    = no (λ ())
_s==?_ Hod      Chochmah = no (λ ())
_s==?_ Hod      Binah    = no (λ ())
_s==?_ Hod      Daat     = no (λ ())
_s==?_ Hod      Chesed   = no (λ ())
_s==?_ Hod      Gevurah  = no (λ ())
_s==?_ Hod      Tiferet  = no (λ ())
_s==?_ Hod      Netzach  = no (λ ())
_s==?_ Hod      Hod      = yes refl
_s==?_ Hod      Yesod    = no (λ ())
_s==?_ Hod      Malchut  = no (λ ())
_s==?_ Yesod    Keter    = no (λ ())
_s==?_ Yesod    Chochmah = no (λ ())
_s==?_ Yesod    Binah    = no (λ ())
_s==?_ Yesod    Daat     = no (λ ())
_s==?_ Yesod    Chesed   = no (λ ())
_s==?_ Yesod    Gevurah  = no (λ ())
_s==?_ Yesod    Tiferet  = no (λ ())
_s==?_ Yesod    Netzach  = no (λ ())
_s==?_ Yesod    Hod      = no (λ ())
_s==?_ Yesod    Yesod    = yes refl
_s==?_ Yesod    Malchut  = no (λ ())
_s==?_ Malchut  Keter    = no (λ ())
_s==?_ Malchut  Chochmah = no (λ ())
_s==?_ Malchut  Binah    = no (λ ())
_s==?_ Malchut  Daat     = no (λ ())
_s==?_ Malchut  Chesed   = no (λ ())
_s==?_ Malchut  Gevurah  = no (λ ())
_s==?_ Malchut  Tiferet  = no (λ ())
_s==?_ Malchut  Netzach  = no (λ ())
_s==?_ Malchut  Hod      = no (λ ())
_s==?_ Malchut  Yesod    = no (λ ())
_s==?_ Malchut  Malchut  = yes refl

-- SoulLevel Equality
_slvl==?_ : (x y : SoulLevel) → Dec (x ≡ y)
_slvl==?_ Nefesh  Nefesh  = yes refl
_slvl==?_ Nefesh  Ruach   = no (λ ())
_slvl==?_ Nefesh  Neshama = no (λ ())
_slvl==?_ Nefesh  Chaya   = no (λ ())
_slvl==?_ Nefesh  Yechida = no (λ ())
_slvl==?_ Ruach   Nefesh  = no (λ ())
_slvl==?_ Ruach   Ruach   = yes refl
_slvl==?_ Ruach   Neshama = no (λ ())
_slvl==?_ Ruach   Chaya   = no (λ ())
_slvl==?_ Ruach   Yechida = no (λ ())
_slvl==?_ Neshama Nefesh  = no (λ ())
_slvl==?_ Neshama Ruach   = no (λ ())
_slvl==?_ Neshama Neshama = yes refl
_slvl==?_ Neshama Chaya   = no (λ ())
_slvl==?_ Neshama Yechida = no (λ ())
_slvl==?_ Chaya   Nefesh  = no (λ ())
_slvl==?_ Chaya   Ruach   = no (λ ())
_slvl==?_ Chaya   Neshama = no (λ ())
_slvl==?_ Chaya   Chaya   = yes refl
_slvl==?_ Chaya   Yechida = no (λ ())
_slvl==?_ Yechida Nefesh  = no (λ ())
_slvl==?_ Yechida Ruach   = no (λ ())
_slvl==?_ Yechida Neshama = no (λ ())
_slvl==?_ Yechida Chaya   = no (λ ())
_slvl==?_ Yechida Yechida = yes refl

-- TNTA Equality
_tnta==?_ : (x y : TNTA) → Dec (x ≡ y)
_tnta==?_ Taamim  Taamim  = yes refl
_tnta==?_ Taamim  Nekudot = no (λ ())
_tnta==?_ Taamim  Tagin   = no (λ ())
_tnta==?_ Taamim  Otiyot  = no (λ ())
_tnta==?_ Nekudot Taamim  = no (λ ())
_tnta==?_ Nekudot Nekudot = yes refl
_tnta==?_ Nekudot Tagin   = no (λ ())
_tnta==?_ Nekudot Otiyot  = no (λ ())
_tnta==?_ Tagin   Taamim  = no (λ ())
_tnta==?_ Tagin   Nekudot = no (λ ())
_tnta==?_ Tagin   Tagin   = yes refl
_tnta==?_ Tagin   Otiyot  = no (λ ())
_tnta==?_ Otiyot  Taamim  = no (λ ())
_tnta==?_ Otiyot  Nekudot = no (λ ())
_tnta==?_ Otiyot  Tagin   = no (λ ())
_tnta==?_ Otiyot  Otiyot  = yes refl

-- DivineName Equality
_name==?_ : (x y : DivineName) → Dec (x ≡ y)
_name==?_ AB  AB  = yes refl
_name==?_ AB  SaG = no (λ ())
_name==?_ AB  MaH = no (λ ())
_name==?_ AB  BaN = no (λ ())
_name==?_ SaG AB  = no (λ ())
_name==?_ SaG SaG = yes refl
_name==?_ SaG MaH = no (λ ())
_name==?_ SaG BaN = no (λ ())
_name==?_ MaH AB  = no (λ ())
_name==?_ MaH SaG = no (λ ())
_name==?_ MaH MaH = yes refl
_name==?_ MaH BaN = no (λ ())
_name==?_ BaN AB  = no (λ ())
_name==?_ BaN SaG = no (λ ())
_name==?_ BaN MaH = no (λ ())
_name==?_ BaN BaN = yes refl

-- Side Equality
_side==?_ : (x y : Side) → Dec (x ≡ y)
_side==?_ RightSide RightSide = yes refl
_side==?_ RightSide LeftSide  = no (λ ())
_side==?_ RightSide Center    = no (λ ())
_side==?_ LeftSide  RightSide = no (λ ())
_side==?_ LeftSide  LeftSide  = yes refl
_side==?_ LeftSide  Center    = no (λ ())
_side==?_ Center    RightSide = no (λ ())
_side==?_ Center    LeftSide  = no (λ ())
_side==?_ Center    Center    = yes refl

-- PanimAchorAspect Equality
_pa==?_ : (x y : PanimAchorAspect) → Dec (x ≡ y)
_pa==?_ Panim  Panim  = yes refl
_pa==?_ Panim  Achor  = no (λ ())
_pa==?_ Panim  BothPA = no (λ ())
_pa==?_ Achor  Panim  = no (λ ())
_pa==?_ Achor  Achor  = yes refl
_pa==?_ Achor  BothPA = no (λ ())
_pa==?_ BothPA Panim  = no (λ ())
_pa==?_ BothPA Achor  = no (λ ())
_pa==?_ BothPA BothPA = yes refl

-- StructureLevel Equality
_structlvl==?_ : (x y : StructureLevel) → Dec (x ≡ y)
_structlvl==?_ UnifiedHei        UnifiedHei        = yes refl
_structlvl==?_ UnifiedHei        VavAs6            = no (λ ())
_structlvl==?_ UnifiedHei        TenDistinctPoints = no (λ ())
_structlvl==?_ UnifiedHei        Partzuf           = no (λ ())
_structlvl==?_ VavAs6            UnifiedHei        = no (λ ())
_structlvl==?_ VavAs6            VavAs6            = yes refl
_structlvl==?_ VavAs6            TenDistinctPoints = no (λ ())
_structlvl==?_ VavAs6            Partzuf           = no (λ ())
_structlvl==?_ TenDistinctPoints UnifiedHei        = no (λ ())
_structlvl==?_ TenDistinctPoints VavAs6            = no (λ ())
_structlvl==?_ TenDistinctPoints TenDistinctPoints = yes refl
_structlvl==?_ TenDistinctPoints Partzuf           = no (λ ())
_structlvl==?_ Partzuf           UnifiedHei        = no (λ ())
_structlvl==?_ Partzuf           VavAs6            = no (λ ())
_structlvl==?_ Partzuf           TenDistinctPoints = no (λ ())
_structlvl==?_ Partzuf           Partzuf           = yes refl

-- MvMPhase Equality
_mvmphase==?_ : (x y : MvMPhase) → Dec (x ≡ y)
_mvmphase==?_ Entering Entering = yes refl
_mvmphase==?_ Entering Exiting  = no (λ ())
_mvmphase==?_ Exiting  Entering = no (λ ())
_mvmphase==?_ Exiting  Exiting  = yes refl

-- InternalZONPresence Equality
_izon==?_ : (x y : InternalZONPresence) → Dec (x ≡ y)
_izon==?_ NoInternalZON  NoInternalZON  = yes refl
_izon==?_ NoInternalZON  HasInternalZON = no (λ ())
_izon==?_ HasInternalZON NoInternalZON  = no (λ ())
_izon==?_ HasInternalZON HasInternalZON = yes refl

-- BYAWorldName Equality
_byaworldname==?_ : (x y : BYAWorldName) → Dec (x ≡ y)
_byaworldname==?_ Beriah   Beriah   = yes refl
_byaworldname==?_ Beriah   Yetzirah = no (λ ())
_byaworldname==?_ Beriah   Assiah   = no (λ ())
_byaworldname==?_ Yetzirah Beriah   = no (λ ())
_byaworldname==?_ Yetzirah Yetzirah = yes refl
_byaworldname==?_ Yetzirah Assiah   = no (λ ())
_byaworldname==?_ Assiah   Beriah   = no (λ ())
_byaworldname==?_ Assiah   Yetzirah = no (λ ())
_byaworldname==?_ Assiah   Assiah   = yes refl

-- PartzufName Equality
_pn==?_ : (x y : PartzufName) → Dec (x ≡ y)
_pn==?_ AA    AA    = yes refl
_pn==?_ AA    Abba  = no (λ ())
_pn==?_ AA    Ima   = no (λ ())
_pn==?_ AA    ZA    = no (λ ())
_pn==?_ AA    Nukva = no (λ ())
_pn==?_ Abba  AA    = no (λ ())
_pn==?_ Abba  Abba  = yes refl
_pn==?_ Abba  Ima   = no (λ ())
_pn==?_ Abba  ZA    = no (λ ())
_pn==?_ Abba  Nukva = no (λ ())
_pn==?_ Ima   AA    = no (λ ())
_pn==?_ Ima   Abba  = no (λ ())
_pn==?_ Ima   Ima   = yes refl
_pn==?_ Ima   ZA    = no (λ ())
_pn==?_ Ima   Nukva = no (λ ())
_pn==?_ ZA    AA    = no (λ ())
_pn==?_ ZA    Abba  = no (λ ())
_pn==?_ ZA    Ima   = no (λ ())
_pn==?_ ZA    ZA    = yes refl
_pn==?_ ZA    Nukva = no (λ ())
_pn==?_ Nukva AA    = no (λ ())
_pn==?_ Nukva Abba  = no (λ ())
_pn==?_ Nukva Ima   = no (λ ())
_pn==?_ Nukva ZA    = no (λ ())
_pn==?_ Nukva Nukva = yes refl

-- MochinLevel Equality
_ml==?_ : (x y : MochinLevel) → Dec (x ≡ y)
_ml==?_ MochinLevel.Katnut  MochinLevel.Katnut  = yes refl
_ml==?_ MochinLevel.Katnut  MochinLevel.Gadlut1 = no (λ ())
_ml==?_ MochinLevel.Katnut  MochinLevel.Gadlut2 = no (λ ())
_ml==?_ MochinLevel.Gadlut1 MochinLevel.Katnut  = no (λ ())
_ml==?_ MochinLevel.Gadlut1 MochinLevel.Gadlut1 = yes refl
_ml==?_ MochinLevel.Gadlut1 MochinLevel.Gadlut2 = no (λ ())
_ml==?_ MochinLevel.Gadlut2 MochinLevel.Katnut  = no (λ ())
_ml==?_ MochinLevel.Gadlut2 MochinLevel.Gadlut1 = no (λ ())
_ml==?_ MochinLevel.Gadlut2 MochinLevel.Gadlut2 = yes refl

---------------------------------
-- Utility Function Signatures (Placeholders)
---------------------------------
open import Data.List.Relation.Unary.Any using (Any)  
open import Data.Maybe using (Maybe)  
open import Data.List.Base using (List)  

_∈?_ : {A : Set} → (x : A) → List A → Dec ⊥
_∈?_ _ _ = no (λ ())

updateMap : {A B : Set} -> (A -> B) -> A -> B -> (A -> B)
updateMap f _ _ = f

lookupMapMaybe : {A B : Set} -> A -> (A -> Maybe B) -> Maybe B
lookupMapMaybe key f = f key
