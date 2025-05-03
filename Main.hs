module Main where

import qualified MAlonzo.Code.Hishtalshelut.Rules.Worlds.IgulimYosherRules as R
import qualified MAlonzo.RTE as RTE
import qualified MAlonzo.Code.Hishtalshelut.Engine.Worlds.IgulimYosherEngine as E

main :: IO ()
main = mapM_ putStrLn E.d_hierarchicalTraceText_260
