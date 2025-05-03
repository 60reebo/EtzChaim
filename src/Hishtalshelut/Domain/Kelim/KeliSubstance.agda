{-# OPTIONS --without-K #-}
module Hishtalshelut.Domain.Kelim.KeliSubstance where

-- | Materials for vessels

data KeliSubstance : Set where
  Zahav    : KeliSubstance  -- זהב
  Kesef    : KeliSubstance  -- כסף
  Nechoshet : KeliSubstance -- נחושת
