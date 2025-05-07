# מנוע סימולציות עץ חיים (EtzChaim Simulation Engine)

מנוע הסימולציות החדש מאפשר ניהול, הרצה, וניטור של סימולציות שונות במערכת עץ חיים.

## מבנה התיקיות

- **Engine/Types/** - טיפוסי נתונים בסיסיים למנוע הסימולציות
- **Engine/Runner/** - מנהל הריצה - אחראי על הרצת סימולציות
- **Engine/Scenarios/** - ספריית תרחישים מוכנים להרצה
- **Engine/Templates/** - תבניות ליצירת תרחישים חדשים

## שימוש בסיסי

```haskell
import Engine.Runner.BasicRunner
import Engine.Scenarios.Library

-- הרצת תרחיש לפי מזהה
runScenario (ScenarioId "ein-sof")

-- קבלת רשימת כל התרחישים הזמינים
listScenarios
```

## יצירת תרחיש חדש

1. העתק את התבנית מ-`Engine/Templates/NewScenario.hs`
2. התאם את התרחיש לצרכים שלך
3. הוסף אותו לספריית התרחישים ב-`Engine/Scenarios/Library.hs`

## קשר למימושים קיימים

מנוע הסימולציות החדש משתמש בקוד הקיים (EinSofEngine, TzimtzumEngine וכו') תוך הוספת שכבת ניהול וסטנדרטיזציה. 