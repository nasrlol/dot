(require 'package)

(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;; ============================================================================

(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t
      ring-bell-function 'ignore)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode 0)

(setq cursor-type 'box)

(pixel-scroll-precision-mode -1)
(setq scroll-conservatively 101
      auto-window-vscroll nil
      fast-but-imprecise-scrolling t
      redisplay-dont-pause t)

(set-face-attribute 'default nil
                    :font "JetBrainsMono Nerd Font"
                    :height 170
                    :foreground "#d0d0d0"
                    :background "#000000")

(add-to-list 'default-frame-alist '(background-color . "#000000"))
(setq custom-enabled-themes nil)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "#00ff00"))))
 '(font-lock-comment-face ((t (:foreground "#555555"))))
 '(font-lock-function-name-face ((t (:foreground "#dddddd"))))
 '(font-lock-keyword-face ((t (:foreground "#dddddd" :weight bold))))
 '(font-lock-string-face ((t (:foreground "#aaaaaa"))))
 '(font-lock-type-face ((t (:foreground "#cccccc"))))
 '(font-lock-variable-name-face ((t (:foreground "#cccccc"))))
 '(line-number ((t (:foreground "#444444" :background "#000000"))))
 '(line-number-current-line ((t (:foreground "#00ff00" :background "#000000"))))
 '(region ((t (:background "#222222")))))

(global-hl-line-mode -1)

;;; ============================================================================
;;; Font-lock (RESTORED)
;;; ============================================================================

(global-font-lock-mode 1)
(setq font-lock-maximum-decoration t)

(setq treesit-auto-install nil)
(setq major-mode-remap-alist nil)

;;; ============================================================================
;;; Line numbers (fast)
;;; ============================================================================

(setq display-line-numbers-type t)

(defun nasr/disable-line-numbers-if-large ()
  (when (> (buffer-size) (* 1 1024 1024))
    (display-line-numbers-mode -1)))

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'nasr/disable-line-numbers-if-large)

;;; ============================================================================
;;; Performance hardening
;;; ============================================================================

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      inhibit-compacting-font-caches t
      bidi-display-reordering nil
      frame-resize-pixelwise nil
      window-resize-pixelwise nil)

;;; ============================================================================
;;; Editing behavior
;;; ============================================================================

(setq-default indent-tabs-mode nil
              tab-width 4)

(setq make-backup-files nil
      auto-save-default nil)

(fset 'yes-or-no-p #'y-or-n-p)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;;; ============================================================================
;;; Evil
;;; ============================================================================

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1)
  (setq evil-normal-state-cursor '(box "#00ff00")
        evil-insert-state-cursor '(box "#ff005f")
        evil-visual-state-cursor '(box "#ffaa00")))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package evil-leader
  :after evil
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>"))

;;; ============================================================================
;;; Navigation
;;; ============================================================================

(require 'windmove)
(global-set-key (kbd "C-h") #'windmove-left)
(global-set-key (kbd "C-j") #'windmove-down)
(global-set-key (kbd "C-k") #'windmove-up)
(global-set-key (kbd "C-l") #'windmove-right)

;;; ============================================================================
;;; Core keys
;;; ============================================================================

(evil-leader/set-key
  "w"  #'save-buffer
  "q"  #'kill-current-buffer
  "bd" #'kill-current-buffer
  "ex" #'dired-jump)

(evil-define-key 'normal 'global
  "gd" #'xref-find-definitions
  "gr" #'xref-find-references
  "K"  #'eldoc)

;;; ============================================================================
;;; Modeline
;;; ============================================================================

(setq-default
 mode-line-format
 '("%e "
   (:eval (upcase (symbol-name evil-state)))
   " "
   "%b "
   mode-line-fill
   "%l:%c"))

;;; ============================================================================
;;; C language profile (classic cc-mode)
;;; ============================================================================

(use-package cc-mode
  :ensure nil
  :mode ("\\.c\\'" "\\.h\\'")
  :hook (c-mode . nasr/c-mode-setup))

(defun nasr/c-mode-setup ()
  (setq-local c-basic-offset 4)
  (setq-local indent-tabs-mode nil)
  (setq-local electric-indent-inhibit t))

;;; ============================================================================
;;; Optional LSP (manual)
;;; ============================================================================

(use-package eglot
  :commands eglot
  :config
  (add-to-list 'eglot-server-programs
               '(c-mode . ("clangd"))))

;;; ============================================================================
;;; clang-format (manual)
;;; ============================================================================

(defun nasr/clang-format-buffer ()
  (interactive)
  (unless (executable-find "clang-format")
    (user-error "clang-format not found"))
  (shell-command-on-region
   (point-min) (point-max)
   "clang-format" nil t))

(evil-leader/set-key
  "cf" #'nasr/clang-format-buffer)

;;; ============================================================================
;;; Window splits
;;; ============================================================================

(evil-leader/set-key
  "v" #'split-window-right
  "s" #'split-window-below)

(defun nasr/split-left ()
  (interactive)
  (split-window-right)
  (windmove-left))

(evil-leader/set-key
  "V" #'nasr/split-left)

;;; ============================================================================
;;; Terminal
;;; ============================================================================

(defun nasr/term-right ()
  (interactive)
  (split-window-right)
  (other-window 1)
  (term (getenv "SHELL")))

(defun nasr/term-left ()
  (interactive)
  (split-window-right)
  (other-window 1)
  (term (getenv "SHELL"))
  (windmove-left))

(evil-leader/set-key
  "tt" #'nasr/term-right
  "tT" #'nasr/term-left)

(with-eval-after-load 'term
  (evil-define-key 'terminal term-raw-map
    (kbd "<escape>") #'evil-normal-state))

;;; ============================================================================
;;; Compile / Make
;;; ============================================================================

(setq compile-command "make")
(setq compilation-scroll-output 'first-error)

(evil-leader/set-key
  "mc" #'compile
  "mr" #'recompile)

(evil-define-key 'normal 'global
  "]e" #'next-error
  "[e" #'previous-error)

;;; ============================================================================
;;; Cursor consistency
;;; ============================================================================

(with-eval-after-load 'evil
  (setq evil-normal-state-cursor  '(box "#00ff00")
        evil-insert-state-cursor  '(box "#00ff00")
        evil-visual-state-cursor  '(box "#00ff00")
        evil-replace-state-cursor '(box "#00ff00")
        evil-motion-state-cursor  '(box "#00ff00")
        evil-emacs-state-cursor   '(box "#00ff00")))


;;; ============================================================================
;;; Multiple cursors (self-contained)
;;; ============================================================================

;; Install if missing
(unless (package-installed-p 'multiple-cursors)
  (package-refresh-contents)
  (package-install 'multiple-cursors))

(require 'multiple-cursors)

;; Core bindings
(global-set-key (kbd "C-S-c C-S-c") #'mc/edit-lines)
(global-set-key (kbd "C->")         #'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         #'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     #'mc/mark-all-like-this)

;; Line-based cursors
(global-set-key (kbd "C-c m n") #'mc/mark-next-lines)
(global-set-key (kbd "C-c m p") #'mc/mark-previous-lines)

;; Exit cleanly
(global-set-key (kbd "C-g") #'mc/keyboard-quit)

;; Optional: keep MC predictable
(setq mc/always-run-for-all t)
(setq mc/always-repeat-command t)
(setq mc/insert-numbers-default 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
