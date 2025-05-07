{-# LANGUAGE ForeignFunctionInterface #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}
-- We might need the unused imports if Agda generates different types

module Engine.FFI.AgdaEinSof where

import Foreign.C.String (CString) 
-- Import the necessary MAlonzo module. 
-- Use 'qualified' to avoid name clashes and make it clear where functions come from.
import qualified MAlonzo.Code.Hishtalshelut.Engine.Worlds.EinSofEngine as AgdaEinSofEngine
import MAlonzo.RTE (AgdaAny) -- Might be needed depending on Agda IO types

-- | Haskell function that wraps the call to the Agda-generated function.
--   It calls the function with the name Agda generated (found in previous errors).
getInitialTraceTextHaskell :: IO CString
getInitialTraceTextHaskell = AgdaEinSofEngine.d_getInitialTraceTextEnIO_166 