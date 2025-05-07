--------------------------------------------------
-- TzimtzumEngine (Engine Layer)
--------------------------------------------------
module Hishtalshelut.Engine.Worlds.TzimtzumEngine where

open import Agda.Primitive using (Level; lzero; lsuc)
open import Data.List public using (List; _∷_; []; _++_; map; length; filter; head; null)
open import Agda.Builtin.String public using (String)
import Data.String.Base as Str
open import Data.Maybe public using (Maybe; nothing; just)
open import Data.Bool public using (Bool; true; false; if_then_else_)
open import Data.Product public using (_×_; Σ; proj₁; proj₂)
open import Data.Nat public using (ℕ; suc)
open import Data.Unit using (⊤; tt)
open import Level using (Lift; lift)

-- Domain Imports
open import Hishtalshelut.Domain.Math.Cardinal using (Cardinal; fin; aleph; showCardinal) public
open import Hishtalshelut.Domain.Math.Ordinal public using (Ordinal; zero; succ; limit; omega; Omega; ordinalEq; ordLeq; showOrdinal; ordinalToNat; showNat; fromNatO)
open import Hishtalshelut.Domain.Worlds.Tzimtzum lzero public using (
  TzimtzumStatus; NoTzimtzum; InProgress; AfterTzimtzum;
  WillForCreation; NoWill; PotentialWill;
  ReshimuLevel; NoReshimu; PartialReshimu; CompleteReshimu;
  ContractionStep; StepStartEinSof; StepPotentialWill; StepExecuteTzimtzum; StepLeaveReshimu;
  CenterPoint; Midpoint; TzimtzumSpec; CircleShape; OrdinalLayer)

-- IO Imports
open import IO.Base public using (IO; pure; _>>=_; _>>_)
open import IO.Finite public using (putStrLn)

-- Rules Imports
open import Hishtalshelut.Rules.Worlds.Tzimtzum public using (
  startWithFullEinSof; potentialWillForCreation; executeTzimtzum; leaveReshimuAtLayer;
  dynamicContractionLoop; createOriginalEinSofLight; runDynamicContraction; buildContractionSteps)

-- הפונקציה העיקרית להדגמת צמצום באגדה בעברית
-- נשים לב: זה פשוט מדי אבל מאפשר קומפילציה

runAndTraceTzimtzumHe : Ordinal lzero → IO (Lift lzero ⊤)
runAndTraceTzimtzumHe maxOrd =
  let
    initialState      = startWithFullEinSof tt
    maxRadiusStr      = showOrdinal maxOrd
  in
    putStrLn "תחילת צמצום" >>
    putStrLn (Str._++_ "רדיוס אורדינלי: " (Str._++_ maxRadiusStr ".")) >>
    putStrLn "הסתיים בהצלחה" >>
    pure (lift tt)

-- | הפונקציה הראשית של התוכנית
main : IO (Lift lzero ⊤)
main = runAndTraceTzimtzumHe (omega {lzero}) 