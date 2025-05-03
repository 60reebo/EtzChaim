# מדריך שימוש לספריית הסימולציה

מדריך זה מסביר אילו נתונים ופרמטרים יש להזין בכל שלב של הסימולציה, מה התפקיד של כל שדה במצב (State), ואיך לבנות שלב סימולציה חדש.

---

## עקרונות כלליים
- כל שלב סימולציה הוא מעבר ממצב (State) אחד לשני ע"פ חוקים קבליים־רש"שיים.
- כל מצב כולל את כל הנתונים הנדרשים לייצוג מלא של עולמות, אורות, כלים, תהליכים, ומדדים.
- כל שלב (step) הוא פונקציה טהורה: מצב קודם + פרמטרים → מצב חדש.

---

## מבנה מצב (State) עיקרי

### WorldState
```agda
record WorldState : Set where
  field
    atzilutState  : OlamAtzilutState  -- מצב עולם האצילות (כולל אורות/כלים)
    masach        : Masach            -- מצב המסך
    byaState      : OlamBYAState      -- מצב עולמות בריאה-יצירה-עשיה
    availableMN   : MayinNukvin       -- כמות מ"ן זמינה
    tikkunEffort  : TikkunEffort      -- רמת מאמץ התיקון
```

### LightState (בתוך כל עולם)
```agda
record LightState : Set where
  field
    coord   : RashashCoordinate  -- מיקום מלא: עולם, פרצוף, איבר, עומק, שם אור
    amount  : ℕ                  -- עוצמת האור (מספרית)
    status  : LightStatus        -- סטטוס: נמשך, נשבר, תוקן וכו'
```

### RashashCoordinate
```agda
record RashashCoordinate : Set where
  field
    igul    : ℕ              -- מספר העיגול/רדיוס
    yosher  : ℕ              -- מדרגת הגובה/יושר
    olam    : OlamName       -- עולם (אצילות, בריאה...)
    partzuf : Partzuf        -- פרצוף
    bodyPart: BodyPart       -- איבר
    depth   : List SefirahName -- עומק פנימי (ספירות)
    shemOhr : ShemOhr        -- שם האור (ע"ב/ס"ג/מ"ה/ב"ן וכו')
```

---

## פרמטרים שיש להזין בכל שלב סימולציה

1. **מצב התחלתי (WorldState):**
   - הגדר את כל העולמות, רשימות האורות (LightState), מצב המסך, מ"ן, מאמץ תיקון.
2. **פרטי כל אור (LightState):**
   - מיקום מלא (RashashCoordinate)
   - שם אור (ShemOhr)
   - עוצמה מספרית (amount)
   - סטטוס (status)
3. **פרטי כל כלי/פרצוף/עולם:**
   - לפי הצורך: רשימות כלים, סטטוס פרצופים, מצב עולמות וכו'.
4. **פרמטרי שלב:**
   - חוקים ייחודיים לשלב (למשל: שבירה, תיקון, המשכת אור)
   - ערכי מ"ן, מאמץ, מסך, וכו'.

---

## דוגמה לכתיבת שלב סימולציה

```agda
stepWorld : WorldState → WorldState
stepWorld ws =
  let atzState = ws .WorldState.atzilutState
      masach  = ws .WorldState.masach
      bya     = ws .WorldState.byaState
      mn      = ws .WorldState.availableMN
      effort  = ws .WorldState.tikkunEffort
      -- ... פעולות עדכון על כל אחד
      -- דוג' עדכון אורות לפי ShemOhr
      newAtzState = updateAtzilutLights atzState
      newBYA      = updateBYALights bya
  in mkWorldState newAtzState masach newBYA mn effort
```

---

## טיפים
- ודא שלכל אור/כלי יש RashashCoordinate מלא ושם אור מדויק.
- שלב את ShemOhr (עסמ"ב) ועוצמה מספרית לקבלת מודל עשיר.
- כל שלב סימולציה (step) צריך לקבל מצב מלא, לעבד אותו, ולהחזיר מצב חדש.
- שמור על מודולריות: כל חוק/מעבר כתוב בפונקציה נפרדת.

---

## סיכום
- כל שלב סימולציה דורש מצב מלא, פרטי אורות (כולל שם, עוצמה, מיקום), פרטי כלים, ערכי מסך/מ"ן/מאמץ, וחוקים ייחודיים.
- שמור על מבנה RashashCoordinate אחיד בכל המודולים.
- שלב בין גישת עסמ"ב (שם האור) לגישה כמותית (amount) לקבלת סימולציה מדויקת, קבלית ומתמטית כאחד.

לשאלות, הרחבות או דוגמאות נוספות — ראה קוד/README של RashashCore ו־Simulation או פנה למפתח הראשי.
