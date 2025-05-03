module Main where

import qualified MAlonzo.RTE as RTE
import qualified MAlonzo.Code.Hishtalshelut.Engine.Worlds.IgulimYosherEngine as E
import qualified Data.Text as T
import Control.Monad      (forM_)
import Data.List          (zip)

main :: IO ()
main = do
  let steps = E.d_hierarchicalExpansionSteps_8
      texts = map E.d_stepToText_26 steps
      header = "<html><head><meta charset=\"UTF-8\"><style>body{direction:rtl;text-align:right;font-family:monospace;white-space:pre;}</style></head><body>\n"
      footer = "</body></html>\n"
      linesHtml = [show i ++ ": " ++ T.unpack t ++ "<br>" | (i, t) <- zip [0 :: Int ..] texts]
  writeFile "steps.html" (header ++ concat linesHtml ++ footer)
  putStrLn "הפלט נשמר בקובץ steps.html. פתח אותו בדפדפן לצפייה נוחה מימין לשמאל."

