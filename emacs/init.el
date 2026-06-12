(require 'package)

;; ============================================================================
;; PACKAGE MANAGEMENT
;; ============================================================================

(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(setq package-check-signature nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; ============================================================================
;; UI/UX SETTINGS
;; ============================================================================

;; Startup
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t
      ring-bell-function 'ignore
      use-dialog-box nil)

;; Remove default UI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Cursor
(setq cursor-type 'box)
(blink-cursor-mode 0)

;; Line wrapping
(setq-default word-wrap nil)
(setq truncate-lines t)

;; Auto-revert buffers when files change on disk
(global-auto-revert-mode 1)

;; ============================================================================
;; PERFORMANCE & COMPILATION
;; ============================================================================

;; Native compilation settings (Emacs 28+)
(setq native-comp-async-report-warnings-errors nil
      native-comp-speed 2)

;; Garbage collection and process I/O optimization
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      inhibit-compacting-font-caches t
      bidi-display-reordering nil
      frame-resize-pixelwise nil
      window-resize-pixelwise nil)

;; ============================================================================
;; APPEARANCE & THEMING
;; ============================================================================

;; Font and colors
(set-face-attribute 'default nil
                    :font "Comic Mono"
                    :height 120
                    :foreground "#A08563"
                    :background "#042327")

(add-to-list 'default-frame-alist '(background-color . "#042327"))
(setq custom-enabled-themes nil)

;; Face customization (syntax highlighting)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "#00ff00"))))
 '(font-lock-comment-face ((t (:foreground "#999999"))))
 '(font-lock-function-name-face ((t (:foreground "#dddddd"))))
 '(font-lock-keyword-face ((t (:foreground "#aaaaaa")))))

;; ============================================================================
;; DEFAULTS & PATHS
;; ============================================================================

;; OS-specific default directory
(setq-default default-directory
              (if (eq system-type 'windows-nt)
                  "C:/dev/projects"
                "/home/nasr"))

;; ============================================================================
;; PACKAGE CONFIGURATION
;; ============================================================================

;; Evil mode (Vim keybindings)
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

(use-package fzf
  :bind ("C-c f" . fzf/local-directory-only)
  :config
  (defun fzf/local-directory-only ()
    "Run fzf strictly on files in the current local directory."
    (interactive)
    (let ((fzf/project-root-function (lambda () default-directory)))
      (fzf))))

;; Project management
(use-package projectile
  :config
  (projectile-mode 1)
  (evil-leader/set-key "p" #'projectile-command-map))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
