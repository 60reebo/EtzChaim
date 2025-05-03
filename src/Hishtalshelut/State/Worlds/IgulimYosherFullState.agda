--------------------------------------------------
-- IgulimYosherFullState (State Layer)
--------------------------------------------------
module Hishtalshelut.State.Worlds.IgulimYosherFullState where

open import Hishtalshelut.Domain.Worlds.IgulimYosher using (PartzufId ; CircleDesc ; YosherDesc ; KavState)
open import Data.List
open import Agda.Builtin.Bool
open import Data.Product using (_×_)
open import Hishtalshelut.Domain.Worlds.EinSof using (EinSof; einsOf)

-- | מצב מלא של מבנה עיגולים/יושר/מקיפים בכל הפרצופים והעולמות
record IgulimYosherFullState : Set where
  field
    -- עיגולים (פנימיים וחיצוניים) לכל פרצוף
    circlesByPartzuf : List (PartzufId × List CircleDesc)
    -- יושר (פנימי/מקיף) לכל פרצוף
    yosherByPartzuf  : List (PartzufId × List YosherDesc)
    -- היררכיה: מי עוטף את מי
    hierarchy        : List (PartzufId × List PartzufId)
    -- קו
    kavState         : KavState

open IgulimYosherFullState public

-- | מצב ראשוני ריק
initialIgulimYosherFullState : IgulimYosherFullState
initialIgulimYosherFullState = record
  { circlesByPartzuf = []
  ; yosherByPartzuf  = []
  ; hierarchy        = []
  ; kavState         = record { headAttached = true ; tailAttached = false ; einsofValue = einsOf }
  }
