module Hishtalshelut.Domain.Rashash.Names.ShemOhr where

open import Data.Bool using (Bool; true; false)

-- | Names of lights (basic and compound)
data ShemOhr : Set where
  AB       : ShemOhr  -- ע"ב
  SAG      : ShemOhr  -- ס"ג
  MAH      : ShemOhr  -- מ"ה
  BEN      : ShemOhr  -- ב"ן
  AB_SAG   : ShemOhr  -- ע"ב דס"ג
  SAG_MAH  : ShemOhr  -- ס"ג דמ"ה
  MAH_BEN  : ShemOhr  -- מ"ה דב"ן
  AB_MAH   : ShemOhr  -- ע"ב דמ"ה
  SAG_BEN  : ShemOhr  -- ס"ג דב"ן

-- | Boolean equality for light names
_≟ShemOhr_ : ShemOhr → ShemOhr → Bool
AB       ≟ShemOhr AB      = true
SAG      ≟ShemOhr SAG     = true
MAH      ≟ShemOhr MAH     = true
BEN      ≟ShemOhr BEN     = true
AB_SAG   ≟ShemOhr AB_SAG  = true
SAG_MAH  ≟ShemOhr SAG_MAH = true
MAH_BEN  ≟ShemOhr MAH_BEN = true
AB_MAH   ≟ShemOhr AB_MAH  = true
SAG_BEN  ≟ShemOhr SAG_BEN = true
_        ≟ShemOhr _       = false

-- | Primary light name for compound names
mainShem : ShemOhr → ShemOhr
mainShem AB      = AB
mainShem SAG     = SAG
mainShem MAH     = MAH
mainShem BEN     = BEN
mainShem AB_SAG  = AB
mainShem SAG_MAH = SAG
mainShem MAH_BEN = MAH
mainShem AB_MAH  = AB
mainShem SAG_BEN = SAG
