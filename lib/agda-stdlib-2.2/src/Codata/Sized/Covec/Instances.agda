------------------------------------------------------------------------
-- The Agda standard library
--
-- Typeclass instances for Covec
------------------------------------------------------------------------


module Codata.Sized.Covec.Instances where

open import Codata.Sized.Covec.Effectful

instance
  covecFunctor = functor
  covecApplicative = applicative
