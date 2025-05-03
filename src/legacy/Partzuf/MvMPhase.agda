--------------------------------------------------
-- MvMPhase (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Partzuf.MvMPhase where

data MvMPhase : Set where
  Entering : MvMPhase
  Exiting  : MvMPhase
