;;; nasr-haskell.el --- Haskell setup -*- lexical-binding: t; -*-

;; Plain-GHC setup for single-file programs (system ghc from portage):
;;   - haskell-mode + interactive-haskell-mode with a ghci REPL
;;   - C-c C-l loads the file into ghci, C-c C-z jumps to the REPL
;;   - C-c r runs the file with runghc
;;   - eglot only kicks in if haskell-language-server is ever installed

(defun nasr/haskell-run ()
  "Save and run the current file with runghc."
  (interactive)
  (save-buffer)
  (compile (concat "runghc " (shell-quote-argument buffer-file-name))))

(defun nasr/haskell-maybe-eglot ()
  "Start eglot when haskell-language-server is available."
  (when (executable-find "haskell-language-server-wrapper")
    (eglot-ensure)))

(use-package haskell-mode
  :hook ((haskell-mode . interactive-haskell-mode)
         (haskell-mode . nasr/haskell-maybe-eglot)
         (haskell-mode . completion-preview-mode))
  :bind (:map haskell-mode-map
              ("C-c r" . nasr/haskell-run))
  :custom
  (haskell-process-type 'ghci)
  (haskell-process-log nil)
  (haskell-interactive-popup-errors nil))

;;; nasr-haskell.el ends here
