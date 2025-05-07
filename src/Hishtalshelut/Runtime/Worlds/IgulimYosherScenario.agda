{-# OPTIONS --guardedness --no-termination-check #-}
module Hishtalshelut.Runtime.Worlds.IgulimYosherScenario where

open import Agda.Primitive using (lzero)
open import Data.List.Base using (List)
open import Agda.Builtin.String using (String)
open import Hishtalshelut.Engine.Worlds.IgulimYosherEngine using (hierarchicalTraceText)

-- | תרחיש ריצה: פלט היררכי מתורגם לטקסט
runScenarioIgulimYosherText : List String
runScenarioIgulimYosherText = hierarchicalTraceText