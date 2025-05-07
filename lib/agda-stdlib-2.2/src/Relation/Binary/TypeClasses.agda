------------------------------------------------------------------------
-- The Agda standard library
--
-- Typeclasses for use with instance arguments
------------------------------------------------------------------------


module Relation.Binary.TypeClasses where

open import Relation.Binary.Structures using (IsDecEquivalence; IsDecTotalOrder) public

open IsDecEquivalence {{...}} using (_≟_) public
open IsDecTotalOrder {{...}} using (_≤?_) public
