--------------------------------------------------
-- Cardinal (Domain Layer)
--------------------------------------------------
module Hishtalshelut.Domain.Cardinal where

open import Agda.Builtin.String using (String)
import Data.String.Base as Str using (_++_)

open import Data.Nat using (ℕ; zero; suc)
open import Data.Nat.Show using (show)
open import Data.Bool using (Bool; true; false)
open import Data.Unit using (⊤ ; tt)

-- Corrected the import list based on actual exports from Math.Cardinal
open import Hishtalshelut.Domain.Math.Cardinal public using (Cardinal; fin; aleph; aleph0; _⊕_; _⊗_)
-- Removed: zeroC; succC; limitC; cardinalEq; showCardinal; add; mul; iterate

-- | דוגמה: ℵ₀ = aleph omega (using actual constructors)

-- | השוואת קרדינלים (פשטני)

-- | פונקציות עזר (ניתן להרחיב בהמשך)
-- successor, limit, וכו'.

-- | המרה ממספר טבעי לקרדינל
fromNatCard : ∀ {ℓ} → ℕ → Cardinal ℓ
fromNatCard n = fin n

-- | Convert Cardinal to String for display
showCardinal : ∀ {ℓ} → Cardinal ℓ → String
showCardinal (fin n) = show n
showCardinal (aleph _) = "ℵ"

-- | Addition and multiplication for Cardinal numbers
