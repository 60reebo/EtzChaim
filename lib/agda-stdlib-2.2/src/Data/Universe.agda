------------------------------------------------------------------------
-- The Agda standard library
--
-- Universes
------------------------------------------------------------------------


module Data.Universe where

open import Level

------------------------------------------------------------------------
-- Definition

record Universe u e : Set (suc (u ⊔ e)) where
  field
    U : Set u       -- Codes.
    El : U → Set e  -- Decoding function.
