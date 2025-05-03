{-# OPTIONS --no-main --without-K #-}
--------------------------------------------------
-- CoreTypes/Light (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.CoreTypes.Light (ℓ : Agda.Primitive.Level) where

open import Agda.Primitive using (Level; lsuc)
open import Hishtalshelut.Domain.Math.Cardinal as Card hiding (index)
open import Hishtalshelut.Domain.Math.Ordinal as Ord hiding (zero; _+_; _*_; _^_; omega; Omega)
open import Hishtalshelut.Domain.Worlds.IgulimYosher ℓ using (LightCategory; LightKind; showLightCategory; showLightKind)
open import Agda.Builtin.String using (String)
import Data.String.Base as Str
open import Data.List using (List; []; _∷_)
open import Data.Nat using (ℕ)
open import Data.Maybe using (Maybe; just; nothing)
open import Data.Bool using (Bool; true; false; _∧_; if_then_else_)

-- Import showNat from Ordinal for Tzelem intensity
open Ord using (showNat)

--------------------------------------------------
-- אות צלם (Tzelem Letter)
--------------------------------------------------
data TzelemLetter : Set where
  Tzadi  : TzelemLetter  -- האות צ' - לנר"ן הפנימיים
  Lamed  : TzelemLetter  -- האות ל' - לחיה (מקיף חוזר)
  Mem    : TzelemLetter  -- האות ם' - ליחידה (מקיף ישר)

showTzelemLetter : TzelemLetter → String
showTzelemLetter Tzadi = "Tzadi (צ)"
showTzelemLetter Lamed = "Lamed (ל)"
showTzelemLetter Mem = "Mem (ם)"

--------------------------------------------------
-- מצבי אור (Light Modes)
--------------------------------------------------
data LightMode : Set where
  Pnimi       : LightMode       -- אור פנימי
  Makif_Chozer : LightMode      -- מקיף חוזר (חיה 'ל')
  Makif_Yashar : LightMode      -- מקיף ישר (יחידה 'ם')

showLightMode : LightMode → String
showLightMode Pnimi = "Pnimi"
showLightMode Makif_Chozer = "Makif_Chozer"
showLightMode Makif_Yashar = "Makif_Yashar"

-- | הקשרים בין אותיות צל"ם לרמות נרנח"י ומצבי האור
-- | צ - אותיות לנר"ן הפנימיים
-- | ל - אותיות לחיה (מקיף חוזר)
-- | ם - אותיות ליחידה (מקיף ישר)
record TzelemAssignment : Set where
  constructor mkTzelemAssignment
  field
    letter      : TzelemLetter    -- איזו אות צלם
    level       : LightCategory   -- איזו רמת נרנח"י
    mode        : LightMode       -- פנימי/מקיף חוזר/מקיף ישר
    intensity   : ℕ                -- עוצמת השפעת הצלם

showTzelemAssignment : TzelemAssignment → String
showTzelemAssignment ta =
  let
    s1 = Str._++_ "Tzelem { letter = " (showTzelemLetter (TzelemAssignment.letter ta))
    s2 = Str._++_ s1 ", "
    s3 = Str._++_ s2 "level = "
    s4 = Str._++_ s3 (showLightCategory (TzelemAssignment.level ta))
    s5 = Str._++_ s4 ", "
    s6 = Str._++_ s5 "mode = "
    s7 = Str._++_ s6 (showLightMode (TzelemAssignment.mode ta))
    s8 = Str._++_ s7 ", "
    s9 = Str._++_ s8 "intensity = "
    s10 = Str._++_ s9 (showNat (TzelemAssignment.intensity ta))
    finalS = Str._++_ s10 " }"
  in
    finalS

showMaybeTzelemLetter : Maybe TzelemLetter → String
showMaybeTzelemLetter nothing = "nothing"
showMaybeTzelemLetter (just tl) = showTzelemLetter tl

-- | Light represents actual, active light in the simulation.
--   It is distinct from Reshimu (potential), and should only be used for active light states.
-- | Light represents actual, active light in the simulation (supports transfinite simulation steps).
record Light : Set (lsuc ℓ) where
  constructor mkLight
  field
    power     : Cardinal ℓ    -- Cardinality (עוצמת האור): The quantitative power or intensity of the light, finite or infinite.
    structure : Ordinal ℓ     -- Ordinality (רמת המבנה/סדר): The structural or sequential level of the light (order in emanation).
    category  : LightCategory -- Light category (קטגוריית האור): Nefesh, Ruach, etc. (spiritual quality).
    kind      : LightKind     -- Light kind (סוג האור): Pnimi (inner), Makif (surrounding), etc.
    source    : String        -- Source/identifier (מקור/זיהוי האור): Where the light originates from or its label.
    timestamp : Ordinal ℓ     -- Simulation step (צעד/מצב בזמן הסימולציה): Now supports transfinite/infinite steps (Ordinal ℓ).
    tzelem_letter : Maybe TzelemLetter -- שיוך לאות צלם (צ-ל-ם): אם קיים, מציין את האות צלם של האור.
open Light public

-- Function to display Light
showLight : Light → String
showLight l =
  let
    p1 = Str._++_ "Light { power = " (Card.showCardinal (power l))
    p2 = Str._++_ p1 ", structure = "
    p3 = Str._++_ p2 (Ord.showOrdinal (structure l))
    p4 = Str._++_ p3 ", category = "
    p5 = Str._++_ p4 (showLightCategory (category l))
    p6 = Str._++_ p5 ", kind = "
    p7 = Str._++_ p6 (showLightKind (kind l))
    p8 = Str._++_ p7 ", source = \""
    p9 = Str._++_ p8 (source l)
    p10 = Str._++_ p9 "\", timestamp = "
    p11 = Str._++_ p10 (Ord.showOrdinal (timestamp l))
    p12 = Str._++_ p11 ", tzelem_letter = "
    p13 = Str._++_ p12 (showMaybeTzelemLetter (tzelem_letter l))
    final = Str._++_ p13 " }"
  in
    final

-- | מיזוג שני אורות למקור אור אחד
-- | אפשרויות מיזוג:
-- | 1. "הגברה" - חיבור של power בשני האורות
-- | 2. "העמקה" - המבנה/סדר (structure) מחושב כמקסימום או כחיבור לפי הפרמטר deepStructureMerge
-- | 3. קטגוריית האור והסוג נשמרים מהאור הראשון
-- | 4. מקור מתעדכן לשילוב של שני המקורות
-- | 5. חותמת זמן מתעדכנת למקסימום של שני האורות
mergeLight : Light → Light → Bool → Light
mergeLight light₁ light₂ deepStructureMerge =
  let
    mergedPower = power light₁ ⊕ power light₂
    mergedStructure =
      if deepStructureMerge
      then structure light₁ Ord.+ structure light₂ -- Use Ord.+ explicitly
      else Ord.maxO (structure light₁) (structure light₂) -- Use Ord.maxO explicitly
    mergedCategory = category light₁
    mergedKind = kind light₁
    -- Use Str._++_ for source concatenation
    mergedSource = Str._++_ (Str._++_ (source light₁) "+") (source light₂)
    mergedTimestamp = Ord.maxO (timestamp light₁) (timestamp light₂) -- Use Ord.maxO explicitly
    mergedTzelemLetter = tzelem_letter light₁
  in
    mkLight mergedPower mergedStructure mergedCategory mergedKind mergedSource mergedTimestamp mergedTzelemLetter

-- | שילוב של רשימת אורות
mergeMany : List Light → Bool → Light → Light
mergeMany [] _ defaultLight = defaultLight
mergeMany (x ∷ []) _ _ = x
mergeMany (x ∷ xs) deepStructureMerge _ = 
  mergeLight x (mergeMany xs deepStructureMerge x) deepStructureMerge

-- | האם אור אחד חזק מאחר
-- | מבוסס על השוואת עוצמה (power) ומבנה (structure)
isStrongerLight : Light → Light → Bool
isStrongerLight light₁ light₂ =
  CardP.cardStronger (power light₁) (power light₂) ∧
  OrdP.ordStronger (structure light₁) (structure light₂)
  where
    open import Hishtalshelut.Domain.Math.Cardinal.Properties as CardP using (cardStronger)
    open import Hishtalshelut.Domain.Math.Ordinal.Properties as OrdP using (ordStronger)

-- | יוצר אור פנימי נר"ן מסוג צלם צ'
createNaRaNLight : Cardinal ℓ → Ordinal ℓ → LightCategory → String → Ordinal ℓ → Light
createNaRaNLight pwr strct cat src ts = 
  mkLight pwr strct cat LightKind.Pnimi src ts (just Tzadi)

-- | יוצר אור מקיף חיה מסוג צלם ל'
createChayaLight : Cardinal ℓ → Ordinal ℓ → String → Ordinal ℓ → Light
createChayaLight pwr strct src ts = 
  mkLight pwr strct LightCategory.Chaya LightKind.Makif src ts (just Lamed)

-- | יוצר אור מקיף יחידה מסוג צלם ם'
createYechidaLight : Cardinal ℓ → Ordinal ℓ → String → Ordinal ℓ → Light
createYechidaLight pwr strct src ts = 
  mkLight pwr strct LightCategory.Yechida LightKind.Makif src ts (just Mem)
