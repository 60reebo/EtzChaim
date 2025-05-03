((nil . ((agda2-include-dirs . ("src" "lib/agda-stdlib/src"))
          (eval .
            (progn
              ;; compile-on-save for Haskell
              (add-hook 'after-save-hook #'haskell-compile nil t)
              ;; עבור Agda: compile-on-save עם agda2-mode
              (add-hook 'after-save-hook #'agda2-compile nil t)
              ;; הגדרת 'next-error' להשתמש ב-flymake או בעורך
              (setq-local compilation-error-regexp-alist '(agda))
              )))))
