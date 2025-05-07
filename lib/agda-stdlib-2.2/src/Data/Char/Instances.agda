------------------------------------------------------------------------
-- The Agda standard library
--
-- Instances for characters
------------------------------------------------------------------------


module Data.Char.Instances where

open import Data.Char.Properties

instance
  Char-≡-isDecEquivalence = isDecEquivalence
