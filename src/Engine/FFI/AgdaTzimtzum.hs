{-# LANGUAGE ForeignFunctionInterface #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Engine.FFI.AgdaTzimtzum where

import qualified Data.Text as T

-- | Haskell stub to return Hebrew trace lines
getTzimtzumTraceHebrew :: IO [T.Text]
getTzimtzumTraceHebrew = pure
  [ "שלב 1: הפעלת רצון אלוהי וביצוע צמצום דינמי."
  , ">>> פלט: עלה ברצונו הפשוט לברוא העולמות."
  , "אתחול צמצום דינמי. רדיוס מקסימלי (אורדינלי): 10."
  ]

-- | Haskell stub to return English trace lines
getTzimtzumTraceEnglish :: IO [T.Text]
getTzimtzumTraceEnglish = pure
  [ "Stage 1: Triggering Divine Will and executing dynamic Tzimtzum."
  , ">>> Output: The Simple Will arose to create the worlds."
  , "Dynamic Tzimtzum initialized. Max radius (Ordinal): 10."
  ] 