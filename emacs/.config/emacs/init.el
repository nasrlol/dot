;; -*- lexical-binding: t; -*-
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

(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t
      ring-bell-function 'ignore
      use-dialog-box nil)

(setq make-backup-files nil)
(setq auto-save-default nil)

;; State files live under ~/.local/share/emacs (see early-init.el)
(setq auto-save-list-file-prefix (expand-file-name "auto-save-list/.saves-" nasr/data-dir)
      transient-history-file     (expand-file-name "transient/history.el" nasr/data-dir)
      tramp-persistency-file-name (expand-file-name "tramp" nasr/data-dir)
      project-list-file          (expand-file-name "projects" nasr/data-dir)
      ede-project-placeholder-cache-file (expand-file-name "ede-projects.el" nasr/data-dir)
      semanticdb-default-save-directory (expand-file-name "semanticdb/" nasr/data-dir))

;; Custom writes to an untracked file instead of appending to init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

(menu-bar-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode -1)
(show-paren-mode 1)

;; Cursor
(setq cursor-type 'hbar)
(blink-cursor-mode 1)

;; Line wrapping
(setq-default word-wrap nil)
(setq truncate-lines t)

;; Auto-revert buffers when files change on disk
(global-auto-revert-mode 1)


(setq native-comp-async-report-warnings-errors nil
      native-comp-speed 2)

;; Font
(set-face-attribute 'default nil :font "liberation mono" :height 190)

;; Colors: nasr-theme.el is generated from theme/palette (run theme/gen)
(add-to-list 'custom-theme-load-path user-emacs-directory)
(load-theme 'nasr t)

;; Evil mode 
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1)
  (setq evil-normal-state-cursor `(box ,nasr-theme-cursor-normal)
        evil-insert-state-cursor `(box ,nasr-theme-cursor-insert)
        evil-visual-state-cursor `(box ,nasr-theme-cursor-visual)))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

;; window movement
(global-set-key (kbd "C-h") 'windmove-left)
(global-set-key (kbd "C-l") 'windmove-right)
(global-set-key (kbd "C-j") 'windmove-up)
(global-set-key (kbd "C-k") 'windmove-down)


(global-display-line-numbers-mode -1)
(global-hl-line-mode 1)


; multiple cursors
(use-package multiple-cursors
  :ensure t)

(global-set-key (kbd "C-q") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

(use-package geiser-mit
  :ensure t)

(use-package geiser
  :ensure t
  :custom
  (geiser-active-implementations '(mit))
  (geiser-default-implementation 'mit)
  :config
  (evil-collection-init 'geiser))


;;; dired
(require 'dired-x)
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alh")
(setq dired-mouse-drag-files t)

(setq c-default-style "awk"
      c-set-style "awk"
      c-basic-offset 4)

(require 'ede)
(global-ede-mode t)
