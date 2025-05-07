{-# LANGUAGE OverloadedStrings #-}

module Main where

import Criterion.Main
import qualified MAlonzo.Code.Hishtalshelut.Engine.Worlds.IgulimYosherEngine as E

main :: IO ()
main = defaultMain
  [ bench "hierarchicalTraceLength" $ nf length E.d_hierarchicalTraceText_248
  , bench "contractionTraceLength" $ nf (length . E.d_contractionTraceText_250) 3
  , bench "geometryTraceLength" $ nf length E.d_geometryTraceText_456
  ]
