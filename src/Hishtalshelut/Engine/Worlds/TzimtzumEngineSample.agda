
module Hishtalshelut.Engine.Worlds.TzimtzumEngineSample where

-- Import IO
open import Agda.Builtin.Unit
open import Agda.Builtin.String
open import Agda.Builtin.IO

-- Define primitive IO functions
postulate
  putStrLn : String → IO ⊤
  _>>=_    : ∀ {A B : Set} → IO A → (A → IO B) → IO B
  pure     : ∀ {A : Set} → A → IO A

-- Native IO binding implementation
{-# FOREIGN GHC import qualified Data.Text as Text #-}
{-# FOREIGN GHC import qualified Data.Text.IO as TextIO #-}
{-# COMPILE GHC putStrLn = TextIO.putStrLn #-}
{-# COMPILE GHC _>>=_ = \_ _ -> (>>=) #-}
{-# COMPILE GHC pure = \_ -> pure #-}

-- Simple hello world program
main : IO ⊤
main =
  putStrLn "שלום עולם!" >>= λ _ →
  putStrLn "תהליך הצמצום הושלם!" >>= λ _ →
  pure tt 