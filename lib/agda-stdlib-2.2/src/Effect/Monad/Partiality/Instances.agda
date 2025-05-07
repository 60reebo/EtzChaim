------------------------------------------------------------------------
-- The Agda standard library
--
-- Typeclass instances for _⊥
------------------------------------------------------------------------


module Effect.Monad.Partiality.Instances where

open import Effect.Monad.Partiality

instance
  partialityMonad = monad
