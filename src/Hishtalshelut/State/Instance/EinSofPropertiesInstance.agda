--------------------------------------------------
-- EinSofProperties Instance (State/Instance)
--------------------------------------------------
module Hishtalshelut.State.Instance.EinSofPropertiesInstance where

open import Agda.Builtin.Unit
open import Agda.Builtin.Bool
open import Hishtalshelut.Domain.Worlds.EinSof

{- |
  מופע קונקרטי של מאפייני אין-סוף (instance) – מייצג סטייט פרטי לטיפוס EinSofProperties.
  זה אינו סטייט כולל של כמה טיפוסים, אלא מופע יחיד עבור טיפוס אחד.
-}
einSofProps : EinSofProperties

-- מימוש כל השדות בהתאם לאחידות, חוסר גבול, אי-הבחנה וכו'.
einSofProps = record
  { indistinguishable = λ _ _ → true
  ; hasBoundary      = false
  ; isUniform        = true
  ; mapInvariant     = λ _ _ → true
  ; location         = tt
  ; direction        = tt
  ; receiveFromEinSof = λ _ → tt
  ; description      = "מימוש פורמלי של כל מאפייני אין-סוף: אחידות, חוסר גבול, אי-הבחנה פנימית, כל פעולה מחזירה אותו דבר, אין משמעות למיקום/כיוון, וכל ספירה מקבלת אור באותה מידה."
  }
