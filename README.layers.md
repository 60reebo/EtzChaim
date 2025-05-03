# שכבות הסימולציה במערכת EtzChaim

## 1. Domain/State
- מכיל אך ורק הגדרות סוגי נתונים (state), לדוג' `IgulimYosherFullState`, `CircleDesc`, `YosherDesc`.
- אין כאן חוקים, טרנספורמציות או סימולציה.

## 2. Rules
- מכיל אך ורק חוקים וטרנספורמציות: איך מוסיפים עיגול/יושר, איך נראה שלב היררכי.
- אין כאן הרצה של Trace שלם, רק פונקציות חוקיות.

## 3. Engine
- מריץ את כל שלבי הסימולציה בפועל (Trace), מפעיל את החוקים מה־Rules.
- אחראי להפקת Trace, תרגום לשלבים טקסטואליים, וכו'.

## 4. Runtime/Scenario
- קבצים שמגדירים תרחיש ריצה, ייבוא Engine, והצגת Trace למשתמש/ממשק.

### דגשים
- אין להריץ סימולציה (Trace) מתוך Rules, רק מתוך Engine/Runtime.
- כל חוק בנייה או טרנספורמציה שייך ל־Rules בלבד.
- כל קוד הדפסה/הרצה שייך ל־Engine/Runtime בלבד.
- סדר זה נשמר בכל המערכת ומונע בלבול ותחזוקה קשה.

## דוגמה לזרימת קוד נכונה (Igulim-Yosher):
1. `src/Hishtalshelut/Domain/Worlds/IgulimYosher.agda` — הגדרות CircleDesc, YosherDesc וכו'.
2. `src/Hishtalshelut/State/Worlds/IgulimYosherFullState.agda` — מבני מצב מלאים.
3. `src/Hishtalshelut/Rules/Worlds/IgulimYosherRules.agda` — רק חוקי בנייה ושלבים (אין סימולציה).
4. `src/Hishtalshelut/Engine/Worlds/IgulimYosherEngine.agda` — הרצת Trace, הפקת Trace טקסטואלי.
5. `src/Hishtalshelut/Runtime/Worlds/IgulimYosherScenario.agda` — תרחיש ריצה, הדפסת Trace.

> **שימו לב:** כל חריגה מהסדר הזה תגרום לבלבול, קושי בתחזוקה ושגיאות הרצה.
