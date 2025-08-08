{-# LANGUAGE OverloadedStrings #-}
module Engine.FFI.AgdaTzimtzum where

import qualified Data.Text as T
import qualified MAlonzo.Code.Hishtalshelut.Runtime.Worlds.TzimtzumScenario as TzimtzumScn

getTzimtzumTraceHebrew :: IO [T.Text]
getTzimtzumTraceHebrew =
  pure TzimtzumScn.d_runScenarioTzimtzumTextHebrew_46

getTzimtzumTraceEnglish :: IO [T.Text]
getTzimtzumTraceEnglish =
  pure TzimtzumScn.d_runScenarioTzimtzumTextEnglish_48 