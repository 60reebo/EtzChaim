#!/bin/bash

# בנייה והרצת מנהל סימולציות עץ חיים

echo "=== בניית מנהל סימולציות עץ חיים ==="

# שלב 1: קומפילציה של קוד Agda עם backend של GHC
echo "--- מהדר קוד Agda עבור GHC ---"
# הפקודה המדויקת עשויה להזדקק להתאמות (קבצים, נתיבי include)
agda --ghc --ghc-dont-call-ghc -i src src/Hishtalshelut/Engine/Worlds/EinSofEngine.agda

# בדיקת שגיאה אחרי קומפילציית Agda
if [ $? -ne 0 ]; then
  echo "=== שגיאה בקומפילציית Agda! ==="
  exit 1
fi
echo "--- קומפילציית Agda הסתיימה בהצלחה ---"

# שלב 2: בניית פרויקט Haskell עם Cabal
echo "--- מהדר קוד Haskell ומקשר ---"
cabal build

# בדיקת שגיאה אחרי בניית Cabal
if [ $? -eq 0 ]; then
  echo "=== בנייה הסתיימה בהצלחה ==="
  
  # הרצת התוכנית עם הפרמטרים שהתקבלו
  echo "=== מריץ את מנהל הסימולציות ==="
  cabal run etz-sim -- "$@"
else
  echo "=== שגיאת בנייה! ==="
  exit 1
fi 