# Tzimtzum - Types (Domain Layer)

1. **TzimtzumSpec** [`src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`]
```agda
record TzimtzumSpec : Set where
  field
    center    : CenterPoint
    maxRadius : ℕ
```
תיאור: מכיל את נקודת המרכז (`center`) ורדיוס מקסימלי (`maxRadius`) לתהליך הצמצום.

2. **TzimtzumStatus** [`src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`]
```agda
data TzimtzumStatus : Set where
  NoTzimtzum    : TzimtzumStatus
  AfterTzimtzum : TzimtzumStatus
```
תיאור: מייצג את מצב הצמצום – לפני הצמצום או לאחריו.

3. **WillForCreation** [`src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`]
```agda
data WillForCreation : Set where
  NoWill        : WillForCreation
  PotentialWill : WillForCreation
```
תיאור: רצון לבריאה – פוטנציאלי או נעדר.

4. **ReshimuLevel** [`src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`]
```agda
data ReshimuLevel : Set where
  NoReshimu   : ReshimuLevel
  WithReshimu : ReshimuLevel
```
תיאור: רמת רישימו – ללא רישימו או קיים.

5. **ContractionStep** [`src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`]
```agda
data ContractionStep : Set where
  StepStartEinSof     : ContractionStep
  StepPotentialWill   : ContractionStep
  StepExecuteTzimtzum : ContractionStep
  StepLeaveReshimu    : ContractionStep
```
תיאור: השלבים בסדרת הצמצום – התחלה, רצון, ביצוע, שימור רישימו.

6. **CenterPoint** [`src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`]
```agda
data CenterPoint : Set where
  Midpoint : CenterPoint
```
תיאור: נקודת המרכז המוגדרת לצמצום (Midpoint).

7. **CircleShape** [`src/Hishtalshelut/Domain/Worlds/Tzimtzum.agda`]
```agda
record CircleShape : Set where
  field
    center : CenterPoint
    radius : ℕ
```
תיאור: תיאור צורה גאומטרית – עיגול עם מרכז ורדיוס.
