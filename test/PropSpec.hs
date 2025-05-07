{-# LANGUAGE OverloadedStrings #-}
module PropSpec where

import Test.Hspec
import Test.Hspec.QuickCheck (prop)
import Test.QuickCheck
import qualified MAlonzo.Code.Hishtalshelut.Engine.Worlds.IgulimYosherEngine as E

spec :: Spec
spec = describe "ContractionEngine properties" $ do
  prop "monotonic contraction trace length" $
    forAll (choose (0 :: Integer, 5)) $ \n ->
      length (E.d_contractionTraceText_250 n) < length (E.d_contractionTraceText_250 (n + 1))
