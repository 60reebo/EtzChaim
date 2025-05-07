-ך {-# OPTIONS --guardedness --no-termination-check #-}
module RunInitialEinSofTrace where

-- Import the state generation and formatting functions
open import Hishtalshelut.Engine.Worlds.EinSofEngine using (initialTraceTextEn; initialTraceTextHe; startWithFullEinSof; joinList)
open import Hishtalshelut.State.Worlds.EinSofState using (EinSofState)
open import Agda.Builtin.IO
open import Agda.Builtin.Unit
open import Agda.Builtin.String
import Data.String.Base as Str using (_++_)
open import Data.List using (List; _∷_; []; _++_)

postulate putStrLn : String → IO ⊤
{-# FOREIGN GHC import qualified Data.Text.IO as T #-}
{-# COMPILE GHC putStrLn = T.putStrLn #-}

-- join function moved to EinSofEngine, remove local definition if it existed
-- join : String → List String → String ...

mainEn : IO ⊤
mainEn = 
  let initialState = startWithFullEinSof tt  -- Get the actual initial state
  in putStrLn (joinList "\n" (initialTraceTextEn initialState)) -- Format the state

mainHe : IO ⊤
mainHe = 
  let initialState = startWithFullEinSof tt  -- Get the actual initial state
  in putStrLn (joinList "\n" (initialTraceTextHe initialState)) -- Format the state
                                                                                