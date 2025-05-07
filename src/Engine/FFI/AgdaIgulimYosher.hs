{-# LANGUAGE ForeignFunctionInterface #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Engine.FFI.AgdaIgulimYosher where

import MAlonzo.RTE (AgdaAny)
import qualified Data.Text as T
import qualified MAlonzo.Code.Hishtalshelut.Runtime.Worlds.IgulimYosherScenario as AgdaIgulimYosherScenario

-- | פונקציה ב–Haskell לקבלת פלט ה–trace ההיררכי מטקסט מ–Agda
getIgulimYosherTrace :: IO [T.Text]
getIgulimYosherTrace = return AgdaIgulimYosherScenario.d_runScenarioIgulimYosherText_8 