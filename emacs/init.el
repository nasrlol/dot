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


(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t
      ring-bell-function 'ignore
      use-dialog-box nil)

(setq make-backup-files nil)
(setq auto-save-default nil)

(menu-bar-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode -1)
(show-paren-mode -1)

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



;; Font and colors
(set-face-attribute 'default nil
                    :font "liberation mono"
                    :height 150 
                    :foreground "#C4A882"
                    :background "#000000")

(setq custom-enabled-themes nil)

;; Face customization 
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
 '(minibuffer-prompt ((t (:foreground "#C4A882"))))
 '(mode-line ((t (:background "#C4A882" :foreground "#5A4A38" :box nil))))
 '(mode-line-inactive ((t (:background "#2A1A0A" :foreground "#6B5A45" :box nil))))
 '(region ((t (:background "#3A0A00")))))


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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ede-project-directories '("/home/nasr/compiler" "/home/nasr/tb"))
 '(package-selected-packages nil))
