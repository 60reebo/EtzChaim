module Hishtalshelut.Domain.Rashash.Names.Sefirah where

open import Data.List using (List; _∷_; [])
open import Data.Maybe using (Maybe; just; nothing)
open import Data.Nat.Base using (ℕ)

open import Data.Fin.Base using (Fin; zero; suc; fromℕ; _↑ˡ_; toℕ)
open import Relation.Binary.PropositionalEquality using (_≡_)
open import Data.Bool using (Bool; true; false)
open import Data.Nat.Base using (_≡ᵇ_)

-- | Names of the ten sefirot as indices (0 = Keter, ..., 9 = Malchut)
SefirahName : Set
SefirahName = Fin 10

-- | Constants for the ten sefirot positions
Keter    : SefirahName
Keter    = fromℕ 0 ↑ˡ 9

Chochmah : SefirahName
Chochmah = fromℕ 1 ↑ˡ 8

Binah    : SefirahName
Binah    = fromℕ 2 ↑ˡ 7

Chesed   : SefirahName
Chesed   = fromℕ 3 ↑ˡ 6

Gevurah  : SefirahName
Gevurah  = fromℕ 4 ↑ˡ 5

Tiferet  : SefirahName
Tiferet  = fromℕ 5 ↑ˡ 4

Netzach  : SefirahName
Netzach  = fromℕ 6 ↑ˡ 3

Hod      : SefirahName
Hod      = fromℕ 7 ↑ˡ 2

Yesod    : SefirahName
Yesod    = fromℕ 8 ↑ˡ 1

Malchut  : SefirahName
Malchut  = fromℕ 9 ↑ˡ 0

-- | Boolean equality for sefirot names via ℕ comparison
infix 4 _≟Sefirah_
_≟Sefirah_ : SefirahName → SefirahName → Bool
x ≟Sefirah y = toℕ x ≡ᵇ toℕ y

-- | Parent Sefirah (Nothing for Keter)
getParent : SefirahName → Maybe SefirahName
getParent Keter    = nothing
getParent Chochmah = just Keter
getParent Binah    = just Chochmah
getParent Chesed   = just Binah
getParent Gevurah  = just Chesed
getParent Tiferet  = just Gevurah
getParent Netzach  = just Tiferet
getParent Hod      = just Netzach
getParent Yesod    = just Hod
getParent Malchut  = just Yesod

-- | Children Sefirot (empty for Malchut)
getChildren : SefirahName → List SefirahName
getChildren Keter    = Chochmah ∷ []
getChildren Chochmah = Binah ∷ []
getChildren Binah    = Chesed ∷ []
getChildren Chesed   = Gevurah ∷ []
getChildren Gevurah  = Tiferet ∷ []
getChildren Tiferet  = Netzach ∷ []
getChildren Netzach  = Hod ∷ []
getChildren Hod      = Yesod ∷ []
getChildren Yesod    = Malchut ∷ []
getChildren Malchut  = []

-- | Placeholder ReceptionMode type
data ReceptionMode : Set where
  Simple : ReceptionMode

-- | Reception mode between Sefirot (placeholder logic)
getReceptionMode : SefirahName → SefirahName → ReceptionMode
getReceptionMode _ _ = Simple
