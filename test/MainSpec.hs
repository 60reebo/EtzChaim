module Main where

import Test.Hspec
import qualified MAlonzo.Code.Hishtalshelut.Engine.Worlds.IgulimYosherEngine as E
import qualified DomainSpec as D
import qualified PropSpec as P
import qualified Data.Text as T

main :: IO ()
main = hspec $ do
  describe "IgulimYosherEngine" $ do
    it "produces non-empty trace" $ do
      length E.d_hierarchicalTraceText_248 `shouldSatisfy` (> 0)

    it "all lines non-empty" $ do
      all (not . T.null) E.d_hierarchicalTraceText_248 `shouldBe` True

  D.spec
  P.spec

  describe "ContractionEngine" $ do
    it "produces non-empty contraction trace" $ do
      length (E.d_contractionTraceText_250 3) `shouldSatisfy` (> 0)

    it "all contraction lines non-empty" $ do
      all (not . T.null) (E.d_contractionTraceText_250 3) `shouldBe` True

  describe "GeometryEngine" $ do
    it "produces non-empty geometry trace" $ do
      length E.d_geometryTraceText_456 `shouldSatisfy` (> 0)

    it "all geometry lines non-empty" $ do
      all (not . T.null) E.d_geometryTraceText_456 `shouldBe` True
