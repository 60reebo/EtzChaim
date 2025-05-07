
module EtzChaimRunner where
{-# COMPILE GHC main = runEtzChaimSimulation #-}

open import Agda.Primitive using (lzero)
open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤; tt)

-- Runtime Imports
open import Hishtalshelut.Runtime.SimulationConfig
open import Hishtalshelut.Runtime.SimulationRunner using (runSimulation)

-- Domain Imports
open import Hishtalshelut.Domain.Language using (Language; EN; HE)
open import Hishtalshelut.Domain.Math.Ordinal using (Ordinal; zero; succ; omega)

-- Define a default configuration for the simulation
defaultConfig : SimulationConfig
defaultConfig = record
  { scenariosToRun     = EinSofSetupId ∷ TzimtzumId ∷ [] -- Run EinSof setup then Tzimtzum
  ; language           = HE -- Set default language to Hebrew
  ; logLevel           = Info -- Set default log level to Info
  ; tzimtzumMaxOrdinal = succ (succ (succ (succ zero))) -- Run Tzimtzum up to ordinal 4 (0, 1, 2, 3)
  }

-- Main entry point for our simulation
runEtzChaimSimulation : IO ⊤
runEtzChaimSimulation = runSimulation defaultConfig >>= λ finalState → pure tt -- Run simulation and discard final state 