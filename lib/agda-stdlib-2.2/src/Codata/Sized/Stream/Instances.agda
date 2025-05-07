------------------------------------------------------------------------
-- The Agda standard library
--
-- Typeclass instances for Stream
------------------------------------------------------------------------


module Codata.Sized.Stream.Instances where

open import Codata.Sized.Stream.Effectful

instance
  streamFunctor = functor
  streamApplicative = applicative
  streamComonad = comonad
