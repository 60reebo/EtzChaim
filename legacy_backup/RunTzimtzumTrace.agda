{-# OPTIONS --cubical-compatible #-}
module RunTzimtzumTrace where

-- Import the engine function and necessary types/functions
open import Agda.Builtin.IO
open import Agda.Builtin.Unit using (⊤)
open import Hishtalshelut.Engine.Worlds.TzimtzumEngine using (runAndTraceTzimtzumEn)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; fromNatO; lzero)

-- Define the main function
main : IO ⊤
main = runAndTraceTzimtzumEn (fromNatO 3) -- Run simulation up to ordinal layer 3

-- Add GHC backend compilation pragma
{-# COMPILE GHC main = main #-}                                                                                                                                                                                                         