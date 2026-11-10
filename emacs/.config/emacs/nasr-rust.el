;;; nasr-rust.el --- Rust setup -*- lexical-binding: t; -*-

;; No LSP, no cargo: rust-mode for syntax/indentation, plain `rustc' on the
;; current file through `compile' (errors are clickable in *compilation*,
;; M-g n / M-g p to step through).  Builds run from the file's directory and
;; the binary is named after the file (mender.rs -> ./mender).
;;   C-c b   rustc build       C-c r   build + run
;;   C-c t   build + run tests C-c k   clippy-driver (lints)
;;   C-c c   cargo <prompt>    (still there for crates that use it)
;;   C-c f   rustfmt buffer    (also runs on save)
;;
;; Per-project flags: put this in .dir-locals.el next to the source, e.g.
;;   ((rust-mode . ((nasr/rustc-flags . "--edition 2021 -g -A non_camel_case_types"))))

;; rustup installs into ~/.cargo/bin (system rustc lives in /usr/bin)
(let ((bin (expand-file-name "~/.cargo/bin")))
  (when (file-directory-p bin)
    (add-to-list 'exec-path bin)
    (unless (member bin (split-string (or (getenv "PATH") "") ":"))
      (setenv "PATH" (concat bin ":" (getenv "PATH"))))))

(defvar-local nasr/rustc-flags "--edition 2021 -g"
  "Extra flags passed to rustc / clippy-driver.")
(put 'nasr/rustc-flags 'safe-local-variable #'stringp)

(defun nasr/rustc--command (tool extra &optional run-suffix)
  "Build the current file with TOOL plus EXTRA flags, optionally running it.
RUN-SUFFIX is appended to the binary name; when non-nil the binary is run."
  (unless buffer-file-name (user-error "Buffer is not visiting a file"))
  (save-some-buffers t (lambda () (derived-mode-p 'rust-mode)))
  (let* ((default-directory (file-name-directory buffer-file-name))
         (src (file-name-nondirectory buffer-file-name))
         (out (concat (file-name-base buffer-file-name) (or run-suffix ""))))
    (compile
     (concat tool " " nasr/rustc-flags " " extra
             " -o " (shell-quote-argument out) " " (shell-quote-argument src)
             (if run-suffix (concat " && ./" (shell-quote-argument out)) "")))))

(defun nasr/rustc-build () (interactive) (nasr/rustc--command "rustc" ""))
(defun nasr/rustc-run ()   (interactive) (nasr/rustc--command "rustc" "" ""))
(defun nasr/rustc-test ()  (interactive) (nasr/rustc--command "rustc" "--test" "-test"))
(defun nasr/rustc-clippy ()
  (interactive)
  ;; --emit=metadata: lint only, don't produce a binary
  (nasr/rustc--command "clippy-driver" "--emit=metadata"))

(defun nasr/cargo (args)
  "Run `cargo ARGS' from the crate root."
  (interactive "scargo ")
  (let ((default-directory (or (locate-dominating-file default-directory "Cargo.toml")
                               default-directory)))
    (save-some-buffers t (lambda () (derived-mode-p 'rust-mode)))
    (compile (concat "cargo " args))))

(use-package rust-mode
  :mode "\\.rs\\'"
  :bind (:map rust-mode-map
              ("C-c r" . nasr/rustc-run)
              ("C-c b" . nasr/rustc-build)
              ("C-c t" . nasr/rustc-test)
              ("C-c k" . nasr/rustc-clippy)
              ("C-c c" . nasr/cargo)
              ("C-c f" . rust-format-buffer))
  :custom
  (rust-format-on-save t)
  (rust-indent-offset 4))

;; Cargo.toml highlighting (conf-toml-mode is built in)
(add-to-list 'auto-mode-alist '("Cargo\\.lock\\'" . conf-toml-mode))

;;; nasr-rust.el ends here
