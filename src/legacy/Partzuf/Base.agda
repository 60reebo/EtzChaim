-- טיפוסים משותפים לפרצופים
module Hishtalshelut.State.Partzuf.Base where

open import Hishtalshelut.State.LightState public using (LightStateAkudim; emptyAkudimLightState)
open import Data.List.Base
open import Data.Maybe
open import Data.Bool

open import Hishtalshelut.Domain.All public hiding (_<_)
open import Hishtalshelut.State.Partzuf.SefirahStateInPartzuf public
open import Hishtalshelut.State.Partzuf.MochinState public using (MochinState; initialMochin_Katnut)

data OrientationState : Set where
  PBP : OrientationState
  ABA : OrientationState
  PAP : OrientationState

record PartzufState : Set where
  inductive
  constructor mkPS
  field
    name            : PartzufName
    internalSefirot : Sefirah → SefirahStateInPartzuf
    mochin          : MochinState
    clothes         : Maybe PartzufName
    clothedBy       : List PartzufName
    subPartzufim    : List PartzufState
    overallState    : Maybe OrientationState

-- הסרנו את ההגדרה של unformedSefirahState, יש לעדכן בשכבת rules

-- | Default empty sefirah state
unformedSefirahState : SefirahStateInPartzuf
unformedSefirahState = record
  { lightStatus = noLight
  ; isActive    = false
  ; kelimStatus = nothing }

unformedPartzufState : PartzufName → PartzufState
unformedPartzufState pn = mkPS pn (λ _ → unformedSefirahState) initialMochin_Katnut nothing [] [] nothing
