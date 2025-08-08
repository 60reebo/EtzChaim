--------------------------------------------------
-- IgulimYosher (Domain Layer)
--------------------------------------------------
{-# OPTIONS --without-K #-}
module Hishtalshelut.Domain.Worlds.IgulimYosher (ℓ : Agda.Primitive.Level) where

open import Agda.Primitive using (Level ; lsuc ; lzero ; _⊔_)

open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; fromNat; _⊖_; _⊗_)
import Hishtalshelut.Domain.Math.Cardinal as C
open import Agda.Builtin.Nat using (Nat; zero; suc; _-_) ; open import Agda.Builtin.Nat renaming (Nat to ℕ)
open import Agda.Builtin.String
open import Agda.Builtin.Bool using (Bool; true; false)
open import Agda.Builtin.List using (List; []; _∷_)
postulate _∧_ : Bool → Bool → Bool
open import Agda.Builtin.Sigma using (Σ; _,_)
-- Replace postulated sum with an actual data type so we can pattern match
data _⊎_ {a b : Level} (A : Set a) (B : Set b) : Set (a ⊔ b) where
  inj₁ : A → A ⊎ B
  inj₂ : B → A ⊎ B
open import Hishtalshelut.Domain.Worlds.EinSof using (EinSof; einsOf; CircleEinSof; circleOf; KavEinSof; kavOf)
-- open import Agda.Builtin.Nat using (_-_) -- already imported above
open import Agda.Builtin.Maybe using (Maybe; just; nothing)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; limit; fromNatO)

length : ∀ {A : Set} → List A → ℕ
length [] = 0
length (_ ∷ xs) = suc (length xs)

-- ENUMERATIONS FOR WORLDS
data World : Set where
  AdamKadmon : World
  Atzilut     : World
  Beriah      : World
  Yetzirah    : World
  Asiyah      : World

allWorlds : List World
allWorlds = AdamKadmon ∷ Atzilut ∷ Beriah ∷ Yetzirah ∷ Asiyah ∷ []

worldName : World → String
worldName AdamKadmon = "א״ק"
worldName Atzilut     = "אצילות"
worldName Beriah      = "בריאה"
worldName Yetzirah    = "יצירה"
worldName Asiyah      = "עשיה"

worldIndex : World → ℕ
worldIndex AdamKadmon = 0
worldIndex Atzilut     = 1
worldIndex Beriah      = 2
worldIndex Yetzirah    = 3
worldIndex Asiyah      = 4

-- | מזהה עולם
record OlamId : Set where
  field
    name : String
    level : ℕ

-- worldToId moved here after OlamId
worldToId : World → OlamId
worldToId w = record { name = worldName w ; level = worldIndex w }

-- | מזהה פרצוף
record PartzufId : Set where
  field
    name : String
    olam : OlamId
    level : ℕ

-- | מזהה ספירה
record SefirahId : Set where
  field
    name : String
    index : ℕ       -- סיווג ספירה (ℕ): מזהה אינדקס סופי

-- | קטגוריית אור/כלי לפי נרנח"י (חמש מדרגות הנפש)
data LightCategory : Set where
  Nefesh  : LightCategory
  Ruach   : LightCategory
  Neshama : LightCategory
  Chaya   : LightCategory
  Yechida : LightCategory
  Undifferentiated_LightCategory : LightCategory -- Primordial, undifferentiated light

showLightCategory : LightCategory → String
showLightCategory Nefesh = "Nefesh"
showLightCategory Ruach = "Ruach"
showLightCategory Neshama = "Neshama"
showLightCategory Chaya = "Chaya"
showLightCategory Yechida = "Yechida"
showLightCategory Undifferentiated_LightCategory = "Undifferentiated"

-- | סוג האור: פנימי או מקיף
data LightKind : Set where
  Pnimi : LightKind
  Makif : LightKind

showLightKind : LightKind → String
showLightKind Pnimi = "Pnimi"
showLightKind Makif = "Makif"

-- | מצב Kav (קו) המשדר אור
record KavState : Set where
  field
    headAttached : Bool  -- האם ראש הקו מחובר לאין סוף
    tailAttached : Bool  -- האם זנב הקו מחובר לעיגולים/יושר
    einsofValue  : EinSof  -- ערך אור אין-סוף המועבר בצינור

open KavState public

-- | תיאור עיגול
record CircleDesc : Set (lsuc ℓ) where
  field
    olam    : OlamId
    partzuf : PartzufId
    sefirah : SefirahId
    isMakif : Bool
    lightCat : LightCategory
    purity   : Cardinal ℓ  -- Cardinal ℓ: טוהר אינסופי/טרנספיניטי

-- | תיאור יושר
record YosherDesc : Set (lsuc ℓ) where
  field
    olam    : OlamId
    partzuf : PartzufId
    isPnimi : Bool
    isMakif : Bool
    covers  : List CircleDesc
    distance : ℕ      -- מרחק בין פנימי למקיף (ℕ): ידוע כספירה סופית
    lightCat : LightCategory
    purity   : Cardinal ℓ  -- Cardinal ℓ: טוהר אינסופי/טרנספיניטי

-- | שלוש בחינות עיגולים: ימין/שמאל/אמצע
data Triad : Set where
  Yamin : Triad
  Smol  : Triad
  Emtza : Triad

-- | שש בחינות 'ציור אדם': מעלה/מטה/ימין/שמאל/פנים/אחור
data Hexad : Set where
  Maala  : Hexad
  Matah  : Hexad
  Yamin′ : Hexad
  Smol′  : Hexad
  Panim  : Hexad
  Achor  : Hexad

-- | שלוש חלקי גוף: ראש/גוף/רגליים
data DosherP : Set where
  Head : DosherP
  Body : DosherP
  Legs : DosherP

-- ENUMERATIONS FOR PARTZUF
data Partzuf : Set where
  ArichAnpin : Partzuf
  Atik       : Partzuf
  Abba       : Partzuf
  Ima        : Partzuf
  ZeirAnpin  : Partzuf
  NukvaZeirAnpin : Partzuf

allPartzufs : List Partzuf
allPartzufs = Atik ∷ ArichAnpin ∷ Abba ∷ Ima ∷ ZeirAnpin ∷ NukvaZeirAnpin ∷ []

partzufName : Partzuf → String
partzufName ArichAnpin = "אריך אנפין"
partzufName Atik        = "עתיק"
partzufName Abba        = "אבא"
partzufName Ima         = "אמא"
partzufName ZeirAnpin   = "זעיר אנפין"
partzufName NukvaZeirAnpin = "נוקבא דזעיר אנפין"

partzufIndex : Partzuf → ℕ
partzufIndex ArichAnpin = 0
partzufIndex Atik        = 1
partzufIndex Abba        = 2
partzufIndex Ima         = 3
partzufIndex ZeirAnpin   = 4
partzufIndex NukvaZeirAnpin = 5

partzufToId : World → Partzuf → PartzufId
partzufToId w p = record
  { name = partzufName p
  ; olam = worldToId w
  ; level = partzufIndex p
  }

-- ENUMERATIONS FOR SEFIROH
data Sefirah : Set where
  Keter   : Sefirah
  Chochma : Sefirah
  Binah   : Sefirah
  Chesed  : Sefirah
  Gevurah : Sefirah
  Tiferet : Sefirah
  Netzach : Sefirah
  Hod     : Sefirah
  Yesod   : Sefirah
  Malchut : Sefirah

allSefirot : List Sefirah
allSefirot = Keter ∷ Chochma ∷ Binah ∷ Chesed ∷ Gevurah ∷ Tiferet ∷ Netzach ∷ Hod ∷ Yesod ∷ Malchut ∷ []

sefirahName : Sefirah → String
sefirahName Keter   = "כתר"
sefirahName Chochma = "חכמה"
sefirahName Binah   = "בינה"
sefirahName Chesed  = "חסד"
sefirahName Gevurah = "גבורה"
sefirahName Tiferet = "תפארת"
sefirahName Netzach = "נצח"
sefirahName Hod     = "הוד"
sefirahName Yesod   = "יסוד"
sefirahName Malchut = "מלכות"

sefirahIndex : Sefirah → ℕ
sefirahIndex Keter   = 0
sefirahIndex Chochma = 1
sefirahIndex Binah   = 2
sefirahIndex Chesed  = 3
sefirahIndex Gevurah = 4
sefirahIndex Tiferet = 5
sefirahIndex Netzach = 6
sefirahIndex Hod     = 7
sefirahIndex Yesod   = 8
sefirahIndex Malchut = 9

sefirahToId : Sefirah → SefirahId
sefirahToId s = record { name = sefirahName s ; index = sefirahIndex s }

-- IMPLEMENT MAPPING FUNCTIONS
sefirahTriad : Sefirah → Triad
sefirahTriad Keter   = Emtza
sefirahTriad Chochma = Yamin
sefirahTriad Binah   = Smol
sefirahTriad Chesed  = Yamin
sefirahTriad Gevurah = Smol
sefirahTriad Tiferet = Emtza
sefirahTriad Netzach = Yamin
sefirahTriad Hod     = Smol
sefirahTriad Yesod   = Emtza
sefirahTriad Malchut = Emtza

sefirahHexad : Sefirah → Hexad
sefirahHexad Keter   = Panim
sefirahHexad Chochma = Yamin′
sefirahHexad Binah   = Smol′
sefirahHexad Chesed  = Yamin′
sefirahHexad Gevurah = Smol′
sefirahHexad Tiferet = Panim
sefirahHexad Netzach = Yamin′
sefirahHexad Hod     = Smol′
sefirahHexad Yesod   = Matah
sefirahHexad Malchut = Achor

sefirahDosherP : Sefirah → DosherP
sefirahDosherP Keter   = Head
sefirahDosherP Chochma = Head
sefirahDosherP Binah   = Head
sefirahDosherP Chesed  = Body
sefirahDosherP Gevurah = Body
sefirahDosherP Tiferet = Body
sefirahDosherP Netzach = Legs
sefirahDosherP Hod     = Legs
sefirahDosherP Yesod   = Legs
sefirahDosherP Malchut = Legs

-- | פנימיות הנשמה (נרנח"י)
data Narnah : Set where
  Nepesh   : Narnah
  Ruach    : Narnah
  Neshamah : Narnah

-- | כלי פנימי/חיצוני
data VesselKind : Set where
  InnerVessel : VesselKind
  OuterVessel : VesselKind

-- | אור פנימי/מקיף
-- data LightKind : Set where
--   Pnimi : LightKind
--   Makif : LightKind

-- | מפרט מלא לעיגול
record CircleSpec : Set where
  field
    seph       : Sefirah
    narnah     : Narnah
    vesselInner : VesselKind
    vesselOuter : VesselKind
    lightInner  : LightKind
    lightOuter  : LightKind

-- | מפרט מלא ליושר
record YosherSpec : Set where
  field
    seph         : Sefirah
    narnah       : Narnah
    vesselInner  : VesselKind
    vesselOuter  : VesselKind
    lightInner   : LightKind
    lightReturn  : LightKind
    lightStraight : LightKind

-- | חבילה מתווכת לספירה אחת
record SefirahUnit : Set where
  field
    circle : CircleSpec
    yosher : YosherSpec

-- | אור עם קטגוריה ואקטיביות, מבדיל בין Igulim ו-Yosher
record Light : Set (lsuc ℓ) where
  field
    einsofCtx : CircleEinSof ⊎ KavEinSof
    category  : LightCategory
    active    : Bool
    intensity : Cardinal ℓ  -- עוצמת האור (Cardinal ℓ): כמות/עוצמה
    purity    : Cardinal ℓ  -- purity: higher = more refined (light), lower = more "vessel"-like (Cardinal ℓ)
    ordinalLevel : Ordinal ℓ  -- רמת אורדינל (לספירה/אור) – מאפשר ייצוג עוצמות/רמות טרנספיניטיות

-- | שידור אור מהקו לכל עיגול או יושר
transmitLight : KavState → (CircleDesc ⊎ YosherDesc) → Light
transmitLight k (inj₁ c) = record
  { einsofCtx     = inj₁ (circleOf (einsofValue k))
  ; category      = CircleDesc.lightCat c
  ; active        = headAttached k ∧ tailAttached k
  ; intensity     = fromNat (length allSefirot) ⊖ fromNat (SefirahId.index (CircleDesc.sefirah c))
  ; purity        = CircleDesc.purity c
  ; ordinalLevel  = zero
  }
transmitLight k (inj₂ y) = record
  { einsofCtx     = inj₂ (kavOf (einsofValue k))
  ; category      = YosherDesc.lightCat y
  ; active        = headAttached k ∧ tailAttached k
  ; intensity     = fromNat (length allSefirot) ⊖ fromNat (YosherDesc.distance y)
  ; purity        = YosherDesc.purity y
  ; ordinalLevel  = zero
  }

-- | זרם אור פנימי
internalStream : CircleDesc → KavState → Light
internalStream c k = transmitLight k (inj₁ c)

-- | זרם אור חיצוני
externalStream : YosherDesc → KavState → Light
externalStream y k = transmitLight k (inj₂ y)

-- | פונקציות גאומטריות: רדיוס, היקף, שטח, נפח
baseRadius : Cardinal ℓ
baseRadius = fromNat 1

growthFactor : Cardinal ℓ
growthFactor = fromNat 2

radius : ℕ → Cardinal ℓ
radius n = baseRadius ⊗ (C._^_ growthFactor (fromNatO n))

circumference : ℕ → Cardinal ℓ
circumference n = fromNat 2 ⊗ radius n

area : ℕ → Cardinal ℓ
area n = radius n ⊗ radius n

volume : ℕ → Cardinal ℓ
volume n = radius n ⊗ area n

-- | רשימת כל הספירות לצורך מיפוי לפי index
allSefirotList : List Sefirah
allSefirotList = allSefirot

-- | חיפוש ברשימה לפי אינדקס (Maybe)
-- | חיפוש ברשימה לפי אינדקס (Maybe)
listLookup : ∀ {A : Set} → Ordinal ℓ → List A → Maybe A
listLookup zero     []       = nothing
listLookup zero     (x ∷ xs) = just x
listLookup (succ o) []       = nothing
listLookup (succ o) (_ ∷ xs) = listLookup o xs
listLookup (limit _) _       = nothing

-- | המרה מ־SefirahId ל־Sefirah (בסדר מוצפן)
sefirahById : SefirahId → Sefirah
sefirahById sf with listLookup (fromNatO (SefirahId.index sf)) allSefirotList
... | just s  = s
... | nothing = Keter

-- | מיפוי Narnah לכל ספירה
sefirahNarnah : Sefirah → Narnah
sefirahNarnah Keter   = Neshamah
sefirahNarnah Chochma = Neshamah
sefirahNarnah Binah   = Neshamah
sefirahNarnah Chesed  = Ruach
sefirahNarnah Gevurah = Ruach
sefirahNarnah Tiferet = Ruach
sefirahNarnah Netzach = Nepesh
sefirahNarnah Hod     = Nepesh
sefirahNarnah Yesod   = Nepesh
sefirahNarnah Malchut = Nepesh

-- | חבילת ספירה מלאה
sefirahUnit : Sefirah → SefirahUnit
sefirahUnit s = record
  { circle = record { seph = s ; narnah = sefirahNarnah s ; vesselInner = InnerVessel ; vesselOuter = OuterVessel ; lightInner = Pnimi ; lightOuter = Makif }
  ; yosher = record { seph = s ; narnah = sefirahNarnah s ; vesselInner = InnerVessel ; vesselOuter = OuterVessel ; lightInner = Pnimi ; lightReturn = Makif ; lightStraight = Makif }
  }

-- | המרה מ־SefirahId ל־SefirahUnit
sefirahUnitById : SefirahId → SefirahUnit
sefirahUnitById sf = sefirahUnit (sefirahById sf)
