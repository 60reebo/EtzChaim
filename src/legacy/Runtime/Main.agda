module Hishtalshelut.Runtime.Main where

open import Hishtalshelut.Engine.Simulation using (WorldState; initialWorldState; stepWorld)
open import IO.Primitive public using (IO; putStrLn)
open import Data.String using (String)

-- | Placeholder: Convert a WorldState to a printable String
postulate
  showWorldState : WorldState → String

-- | Entry point
main : IO Unit
main = putStrLn (showWorldState initialWorldState)
