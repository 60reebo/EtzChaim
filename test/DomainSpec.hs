module DomainSpec where

import Test.Hspec
import qualified MAlonzo.Code.Hishtalshelut.Domain.Worlds.IgulimYosher as D

spec :: Spec
spec = describe "Domain.Worlds.IgulimYosher" $ do
  it "partzufIndex ArichAnpin == 0" $
    D.d_partzufIndex_198 D.C_ArichAnpin_182 `shouldBe` 0
  it "partzufIndex Ima == 3" $
    D.d_partzufIndex_198 D.C_Ima_188 `shouldBe` 3
  it "sefirahIndex Keter == 0" $
    D.d_sefirahIndex_232 D.C_Keter_208 `shouldBe` 0
  it "sefirahIndex Malchut == 9" $
    D.d_sefirahIndex_232 D.C_Malchut_226 `shouldBe` 9 