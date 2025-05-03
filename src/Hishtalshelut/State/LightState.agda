module Hishtalshelut.State.LightState where

open import Agda.Primitive public
open import Agda.Builtin.Nat public using (Nat)
open import Agda.Builtin.List public using (List; [])
open import Agda.Builtin.Maybe public using (Maybe; just; nothing)
open import Agda.Builtin.Equality public using (_≡_)

open import Hishtalshelut.Domain.Light.LightLevel public
open import Hishtalshelut.Domain.Light.SoulLevel public
open import Hishtalshelut.Domain.Light.LightLevelStatus public
open import Hishtalshelut.Domain.Rashash.Coordinate.Coordinate public using (RashashCoordinate; exampleRashashCoord)

-- Representation of a simple light or vessel state
record LightState : Set where
  constructor mkLightState
  field
    coord  : RashashCoordinate
    amount : LightLevel
    status : LightLevelStatus

-- | Default empty light state
emptyLightState : LightState
emptyLightState = mkLightState exampleRashashCoord 0 initialLLS

-- Aggregated akudim (bindings) light state
record LightStateAkudim : Set where
  constructor mkLSA
  field
    nefesh  : LightLevelStatus
    ruach   : LightLevelStatus
    neshama : LightLevelStatus
    chaya   : LightLevelStatus
    yechida : LightLevelStatus

emptyAkudimLightState : LightStateAkudim
emptyAkudimLightState = mkLSA initialLLS initialLLS initialLLS initialLLS initialLLS
