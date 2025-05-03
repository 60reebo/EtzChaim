# דוגמאות לשימוש בלוגיקת אור בסימולטור EtzChaim

מסמך זה מציג דוגמאות מעשיות לשימוש בפונקציות ובטיפוסים של מערכת EtzChaim, בדגש על עבודה עם אור וכלים.

## תוכן עניינים
1. [יצירת אורות וכלים](#יצירת-אורות-וכלים)
2. [פעולות בסיסיות על אור](#פעולות-בסיסיות-על-אור)
3. [זרימת אור](#זרימת-אור)
4. [סימולציה בסיסית](#סימולציה-בסיסית)
5. [ויזואליזציה](#ויזואליזציה)

---

## יצירת אורות וכלים

### יצירת אור בסיסי

```agda
-- יצירת אור סופי פשוט
simpleLight : Light
simpleLight = mkLight 
  (fin 10)              -- עוצמה: 10 (סופי)
  (succ (succ zero))    -- מבנה: 2 (רמה שניה)
  Nefesh                -- קטגוריה: נפש
  Pnimi                 -- סוג: פנימי
  "Simple Light"        -- מקור/שם: Simple Light
  zero                  -- חותמת זמן: 0

-- יצירת אור אינסופי
infiniteLight : Light
infiniteLight = mkLight 
  (aleph zero)          -- עוצמה: אלף-0 (אינסוף מספרי)
  (limit (\_ → zero))   -- מבנה: אורדינל גבול
  Ruach                 -- קטגוריה: רוח
  Makif                 -- סוג: מקיף
  "Infinite Light"      -- מקור/שם: Infinite Light
  zero                  -- חותמת זמן: 0
```

### יצירת כלי

```agda
-- יצירת כלי בסיסי 
simpleKeli : Keli
simpleKeli = mkKeli
  keterSef              -- ספירה: כתר
  InnerVessel           -- סוג כלי: פנימי
  Zahav                 -- חומר: זהב
  (fin 20)              -- קיבולת: 20
  simpleLight           -- תוכן: האור הפשוט שהגדרנו
  (just "Keter Vessel") -- תווית: Keter Vessel
```

---

## פעולות בסיסיות על אור

### מיזוג שני אורות

```agda
-- מיזוג אורות עם חיבור רגיל (לא עמוק)
mergedLight : Light
mergedLight = mergeLight simpleLight infiniteLight false

-- מיזוג אורות עם חיבור עמוק
deepMergedLight : Light
deepMergedLight = mergeLight simpleLight infiniteLight true
```

### השוואת אורות

```agda
-- בדיקה האם אור אחד חזק מהשני
isStronger : Bool
isStronger = isStrongerLight infiniteLight simpleLight  -- true, כי infiniteLight חזק יותר
```

---

## זרימת אור

### זרימת אור בין כלים

```agda
-- הגדרת כלי מקור ויעד
sourceKeli : Keli
sourceKeli = mkKeli keterSef InnerVessel Zahav (fin 20) simpleLight (just "Source")

targetKeli : Keli
targetKeli = mkKeli chochmaSef InnerVessel Kesef (fin 30) (mkLight (fin 5) zero Nefesh Pnimi "Target" zero) (just "Target")

-- העברת אור בין הכלים
flowResult : Keli × Keli
flowResult = flowLight sourceKeli targetKeli false

-- הכלים המעודכנים אחרי הזרימה
updatedSourceKeli : Keli
updatedSourceKeli = proj₁ flowResult

updatedTargetKeli : Keli
updatedTargetKeli = proj₂ flowResult

-- עוצמת האור בכלי המקור אחרי הזרימה תהיה מופחתת
-- עוצמת האור בכלי היעד תהיה מוגברת

-- מיזוג בין כלים שכנים
mergeResult : Keli × Keli
mergeResult = mergeAdjacentKelim sourceKeli targetKeli true
```

### שבירת כלי

```agda
-- יצירת כלי עם אור חזק מדי
weakKeli : Keli
weakKeli = mkKeli keterSef InnerVessel Zahav (fin 5) infiniteLight (just "Weak Vessel")

-- שבירת הכלי
fragmentedLights : List Light
fragmentedLights = breakKeli weakKeli
```

---

## סימולציה בסיסית

### יצירת צעדים היררכיים 

```agda
-- הגדרת צעדים בסיסיים בעולם האצילות
olamAtzilut : OlamId
olamAtzilut = record { name = "אצילות" ; level = 1 }

partzufArich : PartzufId
partzufArich = record { name = "אריך אנפין" ; olam = olamAtzilut ; level = 1 }

keterSfirah : SefirahId
keterSfirah = record { name = "כתר" ; index = 0 }

-- שלבי יצירת עיגול ויושר בספירת כתר
step1 : HierarchicalStepLocal
step1 = CircleInnerV olamAtzilut partzufArich keterSfirah 5  -- כלי פנימי לעיגול כתר

step2 : HierarchicalStepLocal
step2 = CircleOuterV olamAtzilut partzufArich keterSfirah 10  -- כלי חיצוני לעיגול כתר

step3 : HierarchicalStepLocal
step3 = YosherInnerV olamAtzilut partzufArich keterSfirah 5  -- כלי פנימי ליושר כתר

step4 : HierarchicalStepLocal
step4 = YosherOuterV olamAtzilut partzufArich keterSfirah 10  -- כלי חיצוני ליושר כתר

-- הרצת הצעדים על מצב ההתחלתי
simulationSteps : List IgulimYosherFullState
simulationSteps = 
  let s0 = initialIgulimYosherFullState
      s1 = stepHierarchical step1 s0
      s2 = stepHierarchical step2 s1
      s3 = stepHierarchical step3 s2
      s4 = stepHierarchical step4 s3
  in s0 ∷ s1 ∷ s2 ∷ s3 ∷ s4 ∷ []
```

---

## ויזואליזציה

### המרת צעדים לגיאומטריה 3D

```agda
-- המרת צעד היררכי לצעד גיאומטרי
geometryStep1 : GeometryStep
geometryStep1 = toGeometryStep step1  -- ייצוג 3D של יצירת כלי פנימי לעיגול

geometryStep2 : GeometryStep
geometryStep2 = toGeometryStep step2  -- ייצוג 3D של יצירת כלי חיצוני לעיגול

-- המרת צעד גיאומטרי לטקסט (לויזואליזציה)
vizText1 : String
vizText1 = geometryStepToText geometryStep1

vizText2 : String
vizText2 = geometryStepToText geometryStep2
```

### הרצת סימולציה מלאה

```agda
-- הרצת המנוע המלא ליצירת עולם האצילות
main : IO ⊤
main = putStrLn (joinList "\n" hierarchicalTraceText)
```

---

## דוגמאות לתרחישים נפוצים

### תרחיש 1: העברת אור בין שתי ספירות

```agda
-- תרחיש: העברת אור מכתר לחכמה
transferLightScenario : Keli × Keli → Keli × Keli
transferLightScenario (keterKeli , chochmaKeli) = 
  let -- העבר את האור מכתר לחכמה
      (updatedKeter , updatedChochma) = flowLight keterKeli chochmaKeli true
      
      -- בדוק אם יש שבירת כלים בחכמה (אם האור חזק מדי)
      fragmentedLights = breakKeli updatedChochma
      
      -- אם היתה שבירה, עדכן את החכמה עם האור הראשון ברשימה (פשטני)
      finalChochma = 
        if CardProps.cardStronger (power (content updatedChochma)) (capacity updatedChochma)
        then 
          case fragmentedLights of
            [] → updatedChochma
            (firstLight ∷ _) → updateKeliContent updatedChochma firstLight
        else updatedChochma
  in (updatedKeter , finalChochma)
```

### תרחיש 2: מיזוג אורות בפרצוף שלם

```agda
-- תרחיש: מיזוג כל האורות בפרצוף לאור אחד
mergeAllLightsInPartzuf : OlamId → PartzufId → List (OlamId × PartzufId × List Keli) → Light
mergeAllLightsInPartzuf targetOlam targetPartzuf keliState =
  let -- מצא את כל הכלים בפרצוף המבוקש
      targetPartzufKelim = 
        List.concatMap (λ (o , p , kls) → 
          if (olamIdEq o targetOlam ∧ partzufIdEq p targetPartzuf)
          then List.map content kls
          else []) keliState
      
      -- מזג את כל האורות יחד
      mergedResult = 
        case targetPartzufKelim of
          [] → initialLight
          (firstLight ∷ restLights) → mergeMany (firstLight ∷ restLights) true firstLight
  in mergedResult
```

---

הדוגמאות הנ"ל מראות את הדרך המעשית לעבוד עם אורות וכלים במערכת EtzChaim. לשימוש מתקדם יותר, שקול לשלב הרכיבים השונים לתרחישים מורכבים יותר שמדמים את ההשתלשלות המלאה של האור בעולמות השונים. 