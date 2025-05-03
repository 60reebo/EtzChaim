--------------------------------------------------
-- EinSof (Domain Layer)
--------------------------------------------------
--------------------------------------------------
-- Hishtalshelut.Domain.Worlds.EinSof
--
-- DOMAIN LAYER: Defines the conceptual structure and types for Ein Sof (the Infinite) in the system.
-- This file should only contain static types, enums, and pure functions related to Ein Sof.
-- No state or dynamic logic should appear here!
--------------------------------------------------
module Hishtalshelut.Domain.Worlds.EinSof where

open import Agda.Builtin.Unit
open import Agda.Builtin.Bool
open import Agda.Builtin.String

{- |
  EinSof (אין-סוף):
  הגדרה מתמטית של אור אין-סוף בקבלה – אור פשוט, אחיד, בלתי נתפס, ללא גבול, הבחנה או תכונה פנימית.
  בחרנו לייצג את EinSof כ-unit type (טיפוס יחידה) באגדה, כי מבחינה קבלית ומתמטית:
  - אין שום הבחנה פנימית בין מופעים שונים של אין-סוף.
  - כל תכונה, מידה או תיאור תפר את עקרון הפשטות והאחדות המוחלטת של אין-סוף.
  - זהו ייצוג נאמן לרעיון של אור פשוט שאין בו שום מאפיין או מידע נוסף.
  אם נרצה להוסיף תכונות מתמטיות או תיעוד, נשתמש בטיפוס עוטף (wrapper) ולא נשנה את המהות.
-}

record EinSof : Set where
  constructor einsOf

{- |
  Mathematical properties of EinSof (אור אין-סוף):
  מבוסס על הציטוטים והמאפיינים המרכזיים בטקסט שער א ענף ב:

  * "הכל היה אור א' פשוט שוה בהשוואה א'... לא יצדק בו מעלה ומטה פנים ואחור כי כל הכינונים האלו מורים הם היות קצבה וגבול ותחום ומדה באור א"ס העליון ח"ו"
  * "לא היה לו בחי' ראש ולא בחי' סוף... לא קצבה וגבול ותחום ומדה"
  * "אין לו בחי' ראש ולא בחי' סוף אלא הכל היה אור א' פשוט שוה בהשוואה א' והוא הנק' אור א"ס"
  * "אור א"ס נוקב ועובר בעובי כל ספי' וספי' ומלגאו כל ספי' וספי' ואסחר לון מלבר לכל ספי' וספי' כנזכר בספר הזוהר..."

  המעטפת מאפשרת להוסיף מאפיינים מתמטיים פורמליים, תיעוד, וכלים להוכיח את תכונת האחידות, חוסר גבול, אי-הבחנה פנימית ועוד.
-}
record EinSofProperties : Set where
  field
    -- אין הבחנה פנימית: indistinguishable
    indistinguishable : EinSof → EinSof → Bool
    -- חוסר גבול/מידה
    hasBoundary : Bool
    -- אחידות מוחלטת
    isUniform : Bool
    -- כל פעולה עליו מחזירה אותו דבר
    mapInvariant : (EinSof → EinSof) → EinSof → Bool
    -- אין משמעות למיקום/כיוון
    location    : ⊤
    direction   : ⊤
    -- כל ספירה מקבלת ממנו אור באותה מידה
    receiveFromEinSof : EinSof → ⊤
    -- תיעוד מפורט
    description : String

{- |
  מופע קונקרטי של מאפייני אין-סוף על פי ההגדרות הקבליות והמתמטיות.
  כל שדה ממומש בהתאם לרעיון של אחידות, חוסר גבול, אי-הבחנה וכו'.
-}

-- Wrappers for EinSof in circles (Igulim) and kav (Yosher) contexts:
record CircleEinSof : Set where
  constructor circleOf
  field
    underlying : EinSof

record KavEinSof : Set where
  constructor kavOf
  field
    underlying : EinSof
