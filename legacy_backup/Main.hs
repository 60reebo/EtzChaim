module Main where

import Options.Applicative (execParser, helper, info, fullDesc, header)
import Hishtalshelut.Runtime.Simulation (scenarioParser, runScenario)

main :: IO ()
main = do
  config <- execParser opts
  runScenario config
  where
    opts = info (helper <*> scenarioParser)
      ( fullDesc
     <> header "EtzChaim: Kabbalistic Simulation CLI" )
