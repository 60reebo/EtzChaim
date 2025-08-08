{-# LANGUAGE ForeignFunctionInterface #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Engine.FFI.AgdaEinSof where

import Foreign.C.String (CString, newCString)

-- | Haskell stub that mimics the Agda-generated function.
--   Returns an English header and a couple of log lines as a single CString.
getInitialTraceTextHaskell :: IO CString
getInitialTraceTextHaskell = newCString $ unlines
  [ "# --- Stage 0: Pre-Initialization State (Ein Sof) ---"
  , "LOG \"Stage 0: Defining Ein Sof environment.\""
  , "primordial_ein_sof_light = EinSof_Primordial(...)"
  ] 