module Main where

import qualified MAlonzo.Code.Hishtalshelut.Engine.Worlds.IgulimYosherEngine as E
import qualified Data.Text.IO as TIO

main :: IO ()
main = do
  putStrLn "=== גיאומטריה (תרחיש נפרד) ==="
  mapM_ TIO.putStrLn E.d_geometryTraceText_456
