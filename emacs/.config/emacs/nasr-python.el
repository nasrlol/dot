;;; nasr-python.el --- Python / notebook setup -*- lexical-binding: t; -*-

;; Minimal "anaconda-like" setup built on uv:
;;   - built-in python-mode + eglot (basedpyright) + completion-preview
;;   - per-project .venv picked up automatically (made by `uv init' / `uv add')
;;   - notebooks via code-cells: .ipynb opens as a `# %%' script (jupytext),
;;     cells are sent to an (I)Python REPL, saved back as .ipynb
;;
;; One-time tools:  uv tool install basedpyright ruff jupytext
;; Per project:     uv init && uv add ipython numpy pandas matplotlib

;; uv tool binaries (Emacs may be started outside a login shell)
(let ((bin (expand-file-name "~/.local/bin")))
  (add-to-list 'exec-path bin)
  (unless (member bin (split-string (or (getenv "PATH") "") ":"))
    (setenv "PATH" (concat bin ":" (getenv "PATH")))))

;;; venv

(defun nasr/python-venv ()
  "Return the nearest .venv directory above `default-directory', or nil."
  (when-let* ((dir (locate-dominating-file default-directory ".venv")))
    (expand-file-name ".venv/" dir)))

(defun nasr/python-venv-setup ()
  "Point the REPL at the project .venv, preferring ipython when installed."
  (interactive)
  (let ((venv (nasr/python-venv)))
    (setq-local python-shell-virtualenv-root venv)
    (if (and venv (file-executable-p (expand-file-name "bin/ipython" venv)))
        (setq-local python-shell-interpreter "ipython"
                    python-shell-interpreter-args "-i --simple-prompt")
      (setq-local python-shell-interpreter "python3"
                  python-shell-interpreter-args "-i"))))

(defun nasr/uv (args)
  "Run `uv ARGS' in the project root, e.g. \"add pandas\" or \"sync\"."
  (interactive "suv ")
  (let ((default-directory (or (locate-dominating-file default-directory "pyproject.toml")
                               default-directory)))
    (compile (concat "uv " args))))

;;; editing

;; Emacs 30+ only runs diagnostics (flymake/eglot) in trusted dirs.
(setq trusted-content '("~/dev/" "~/dotfiles/"))

(defun nasr/ruff-format ()
  "Format the buffer with ruff, leaving it untouched on syntax errors."
  (interactive)
  (let ((out (generate-new-buffer " *ruff*")))
    (unwind-protect
        (if (zerop (call-process-region nil nil "ruff" nil out nil "format"
                                        "--stdin-filename" (or buffer-file-name "x.py") "-"))
            (replace-region-contents (point-min) (point-max) out)
          (message "ruff: %s" (with-current-buffer out (string-trim (buffer-string)))))
      (kill-buffer out))))

(use-package python
  :ensure nil
  :hook ((python-mode . nasr/python-venv-setup)
         (python-mode . eglot-ensure)
         (python-mode . completion-preview-mode))
  :bind (:map python-mode-map
              ("C-c f" . nasr/ruff-format)
              ("C-c u" . nasr/uv))
  :custom
  (python-indent-guess-indent-offset-verbose nil))

(use-package eglot
  :ensure nil
  :defer t
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-config '(:size 0))
  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) "basedpyright-langserver" "--stdio"))
  ;; Tell basedpyright which interpreter to resolve imports against.
  (setq-default eglot-workspace-configuration
                (lambda (_server)
                  (when-let* ((venv (nasr/python-venv)))
                    `(:python (:pythonPath ,(expand-file-name "bin/python" venv)))))))

;;; notebooks

(declare-function python-shell-get-process "python")

(defun nasr/code-cells-eval ()
  "Eval the current cell, starting a REPL first if needed."
  (interactive)
  (unless (python-shell-get-process)
    ;; Wait for the first prompt so python.el's setup code runs before ours.
    (let ((proc (run-python nil nil t)))
      (with-timeout (10 (message "python: REPL slow to start"))
        (while (not (buffer-local-value 'python-shell--first-prompt-received
                                        (process-buffer proc)))
          (accept-process-output proc 0.1)))))
  (call-interactively #'code-cells-eval))

(use-package code-cells
  :hook (python-mode . code-cells-mode-maybe)
  :bind (:map code-cells-mode-map
              ("C-c C-c" . nasr/code-cells-eval)
              ("C-c C-n" . code-cells-forward-cell)
              ("C-c C-p" . code-cells-backward-cell)))

;;; nasr-python.el ends here
