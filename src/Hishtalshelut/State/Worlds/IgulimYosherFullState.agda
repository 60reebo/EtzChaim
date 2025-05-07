{-# OPTIONS --without-K #-}
--------------------------------------------------
-- המצב השלם של המערכת עולמות איגולים ויושר (State/Worlds/)
--------------------------------------------------
open import Agda.Primitive using (Level; lzero; lsuc)

module Hishtalshelut.State.Worlds.IgulimYosherFullState (ℓ : Level) where

open import Hishtalshelut.Domain.Worlds.IgulimYosher ℓ using (OlamId ; PartzufId ; SefirahUnit ; KavState ; CircleDesc ; YosherDesc)
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; fromNat)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; limit)
open import Hishtalshelut.Domain.Worlds.Tzimtzum ℓ using (ContractionStep)
open import Hishtalshelut.State.Worlds.TzimtzumState ℓ using (ContractionState; initialContractionState)
open import Hishtalshelut.Domain.Worlds.EinSof using (einsOf)
open import Hishtalshelut.State.Worlds.EinSofState using (EinSofState; initialEinSofState)
open import Hishtalshelut.State.Worlds.IgulimYosherReshimuState ℓ using (ReshimuState; initialReshimuState)
open import Hishtalshelut.Domain.Worlds.IgulimYosherReshimu ℓ using (ReshimuSpec)
open import Hishtalshelut.Domain.LightChain ℓ using (initialLight)
open import Data.List using (List; []; _∷_)
open import Agda.Builtin.Bool
open import Data.Product using (_×_; _,_)
open import Hishtalshelut.Domain.CoreTypes.Keli ℓ using (Keli)
open import Hishtalshelut.State.Light.KeliState ℓ using (KeliState; initialKeliState)
open import Hishtalshelut.Domain.Math.Types using (Positive)
open import Hishtalshelut.Domain.Math.Equality using (_≡_; refl)
open import Function.Base using (_$_; id)

-- | מצב מלא של מבנה עיגולים/יושר/מקיפים בכל הפרצופים והעולמות
record IgulimYosherFullState : Set (lsuc ℓ) where
  constructor mkIgulimYosherFullState
  field
    -- רשימו לפני כניסת הקו
    reshimuState       : ReshimuState
    -- הרכבים לפי פרצוף
    compositeByPartzuf : List (OlamId × PartzufId × List SefirahUnit)
    -- מצב הקו
    kavState           : KavState
    -- מצב צמצום
    contractionState   : ContractionState
    -- רמות אורדינל וכמותיות לכל יחידת ספירה
    ordinalLevels      : List (OlamId × PartzufId × Ordinal ℓ)
    cardinalLevels     : List (OlamId × PartzufId × Cardinal ℓ)
    -- מצב של הכלים לכל פרצוף
    kelimByPartzuf     : List (OlamId × PartzufId × List Keli)

open IgulimYosherFullState public

-- | מצב ראשוני ריק
initialIgulimYosherFullState : IgulimYosherFullState
initialIgulimYosherFullState = record
  { reshimuState       = initialReshimuState
  ; compositeByPartzuf = []
  ; kavState           = record { headAttached = true ; tailAttached = false ; einsofValue = einsOf }
  ; contractionState   = initialContractionState initialLight initialEinSofState
  ; ordinalLevels      = []
  ; cardinalLevels     = []
  ; kelimByPartzuf     = []
  }

-- | Stub: list of circles per Partzuf for engine
circlesByPartzuf : IgulimYosherFullState → List (OlamId × List CircleDesc)
circlesByPartzuf _ = []

-- | Stub: list of yosher per Partzuf for engine
yosherByPartzuf : IgulimYosherFullState → List (OlamId × List YosherDesc)
yosherByPartzuf _ = []
