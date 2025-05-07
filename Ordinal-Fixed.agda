-- יתר המקרים
assocMaxO (succ a) (succ b) (limit h) =
  begin
    maxO (maxO (succ a) (succ b)) (limit h)
  ≡⟨⟩
    maxO (succ (maxO a b)) (limit h)
  ≡⟨⟩
    limit (λ n → maxO (succ (maxO a b)) (h n))
  ≡⟨ cong limit (funExt (λ n → 
      let
        h-n-nonzero = h n -- הנחה שסדרת הגבול לא מכילה zero
        -- כאשר h n = zero: maxO (succ a') zero = succ a'
        -- כאשר h n = succ b', אז maxO (succ a') (succ b') = succ (maxO a' b')
      in 
      case isSucc (h n) of λ where
        true → cong succ (maxSuccAssoc a b (pred (h n)) (assocMaxO a b (pred (h n))))
        false → refl)) ⟩
    limit (λ n → maxO (succ a) (maxO (succ b) (h n)))
  ≡⟨⟩
    maxO (succ a) (maxO (succ b) (limit h))
  ∎
  where
    isSucc : ∀ {ℓ} → Ordinal ℓ → Bool
    isSucc zero = false
    isSucc (succ _) = true
    isSucc (limit _) = false
    
    pred : ∀ {ℓ} → Ordinal ℓ → Ordinal ℓ
    pred zero = zero
    pred (succ x) = x
    pred (limit f) = limit (λ n → pred (f n)) 