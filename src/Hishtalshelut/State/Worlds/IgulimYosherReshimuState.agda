{-# OPTIONS --without-K #-}
--------------------------------------------------
-- ReshimuState (State Layer for IgulimYosher)
--------------------------------------------------
open import Agda.Primitive using (Level; lzero; lsuc)
module Hishtalshelut.State.Worlds.IgulimYosherReshimuState (ℓ : Level) where

open import Data.Nat using (ℕ; zero; suc)

open import Data.List using (List; []; _∷_; concatMap; map)
open import Data.Product using (_×_; _,_)
open import Hishtalshelut.Domain.Worlds.IgulimYosherReshimu ℓ using (ReshimuSpec; seph; vesselInner; vesselOuter; toReshimuSpec)
open import Hishtalshelut.Domain.Worlds.IgulimYosher ℓ using (World; allWorlds; worldToId; Partzuf; allPartzufs; partzufToId; OlamId; PartzufId; allSefirotList; SefirahUnit; sefirahUnit)

-- | State of Reshimu imprints before Kav enters
record ReshimuState : Set (lsuc ℓ) where
  constructor MkReshimuState
  field
    reshimuByPartzuf : List (OlamId × PartzufId × List ReshimuSpec)

open ReshimuState public

-- | Initial ReshimuState: imprint list per Partzuf/Olam from all SefirahUnits
initialReshimuState : ReshimuState
initialReshimuState = MkReshimuState
  ( concatMap (λ w →
      let ol    = worldToId w
      in  map (λ p →
            let pid   = partzufToId w p
                units = map sefirahUnit allSefirotList
                specs = map toReshimuSpec units
            in (ol , pid , specs))
          allPartzufs)
    allWorlds
  )
