--------------------------------------------------
-- Math Enums (Domain/Math)
--------------------------------------------------
module Hishtalshelut.Domain.Math.Enums where

open import Agda.Primitive using (lzero)
open import Hishtalshelut.Domain.Worlds.IgulimYosher lzero using (LightCategory; Undifferentiated_LightCategory; DosherP; Sefirah)
open import Agda.Builtin.String using (String)
open import Data.Nat using (ℕ; zero; suc)

-- | Qualities of light: alias of LightCategory
LightQuality = LightCategory

-- | Primordial undifferentiated light quality
Primordial_LightQuality : LightQuality
Primordial_LightQuality = Undifferentiated_LightCategory

-- | Level enumeration (domain-specific, generic levels)
data GenLevel : Set where
  Low    : GenLevel
  Medium : GenLevel
  High   : GenLevel

-- | Positions for parts: alias of DosherP
Position = DosherP

-- | Names of the Sefirot: alias of Sefirah
SefirahName = Sefirah
