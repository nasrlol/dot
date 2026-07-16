;; (require "lib.el")
(require 'package)

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

;; Startup
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t
      ring-bell-function 'ignore
      use-dialog-box nil)

;; Cursor
(setq cursor-type 'hbar)
(blink-cursor-mode 1)

;; Line wrapping
(setq-default word-wrap nil)
(setq truncate-lines t)

;; Auto-revert buffers when files change on disk
(global-auto-revert-mode 1)

;; Visual tweaks
(set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?┃))
(global-hl-line-mode 1)

;; Font
(set-face-attribute 'default nil
                    :font "Liberation Mono"
                    :height 150 
                    :foreground "#C4A882"
                    :background "#000000")

;; Colors
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "#F0A030"))))
 '(font-lock-builtin-face ((t (:foreground "#D4A030"))))
 '(font-lock-comment-face ((t (:foreground "#6B5A45"))))
 '(font-lock-constant-face ((t (:foreground "#9B7040"))))
 '(font-lock-function-name-face ((t (:foreground "#C4A882"))))
 '(font-lock-keyword-face ((t (:foreground "#D48B30"))))
 '(font-lock-preprocessor-face ((t (:foreground "#C05020"))))
 '(font-lock-string-face ((t (:foreground "#B86030"))))
 '(font-lock-type-face ((t (:foreground "#B87040"))))
 '(font-lock-variable-name-face ((t (:foreground "#C4A882"))))
 '(font-lock-warning-face ((t (:foreground "#DC4A20"))))
 '(hl-line ((t (:background "#1F1610"))))
 '(isearch ((t (:background "#3D2B1A" :foreground "#C4A882"))))
 '(lazy-highlight ((t (:background "#3D2B1A"))))
 '(line-number ((t (:foreground "#5A4A38"))))
 '(line-number-current-line ((t (:foreground "#D48B30"))))
 '(mode-line ((t (:background "#C4A882" :foreground "#5A4A38" :box nil))))
 '(region ((t (:background "#3A0A00"))))
 '(vertical-border ((t (:foreground "#333333")))))

;; Evil mode
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1)
  (setq evil-normal-state-cursor '(box "#F0A030")
        evil-insert-state-cursor '(box "#C04018")
        evil-visual-state-cursor '(box "#D48B30")))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

;; Window movement
(global-set-key (kbd "C-h") 'windmove-left)
(global-set-key (kbd "C-l") 'windmove-right)
(global-set-key (kbd "C-j") 'windmove-up)
(global-set-key (kbd "C-k") 'windmove-down)

(global-ede-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ede-project-directories
   '("/Users/nasr/Dev/asteroids" "/Users/nasr/Dev/asteroids/src"
     "/Users/nasr/Dev/compiler")))
