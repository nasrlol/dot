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
      ring-bell-function 'ignore)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode 0)
(global-auto-revert-mode 1)

(setq cursor-type 'box)

(setq-default default-directory "C:\dev\projects")

(set-face-attribute 'default nil
                    :font "Comic Mono"
                    :height 120
                    :foreground "#A08563"
                    :background "#042327")

(add-to-list 'default-frame-alist '(background-color . "#042327"))
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
 '(region ((t (:background "#222222")))))

(global-hl-line-mode -1)

(global-font-lock-mode 1)
(setq font-lock-maximum-decoration t)

(setq treesit-auto-install nil)
(setq major-mode-remap-alist nil)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      inhibit-compacting-font-caches t
      bidi-display-reordering nil
      frame-resize-pixelwise nil
      window-resize-pixelwise nil)

(setq-default indent-tabs-mode nil
              tab-width 1)

(setq make-backup-files nil
      auto-save-default nil)

(fset 'yes-or-no-p #'y-or-n-p)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

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

(require 'windmove)
(global-set-key (kbd "C-h") #'windmove-left)
(global-set-key (kbd "C-j") #'windmove-down)
(global-set-key (kbd "C-k") #'windmove-up)
(global-set-key (kbd "C-l") #'windmove-right)

(evil-leader/set-key
  "w"  #'save-buffer
  "q"  #'kill-current-buffer
  "bd" #'kill-current-buffer
  "ex" #'dired-jump)

(evil-define-key 'normal 'global
  "gd" #'xref-find-definitions
  "gr" #'xref-find-references
  "K"  #'eldoc)

(setq-default
 mode-line-format
 '("%e "
   (:eval (upcase (symbol-name evil-state)))
   " "
   "%b "
   mode-line-fill
   "%l:%c"))

(evil-leader/set-key
  "v" #'split-window-right
  "s" #'split-window-below)

(defun nasr/split-left ()
  (interactive)
  (split-window-right)
  (windmove-left))

(evil-leader/set-key
  "V" #'nasr/split-left)


(evil-define-key 'normal 'global
  "]e" #'next-error
  "[e" #'previous-error)

(with-eval-after-load 'evil
  (setq evil-normal-state-cursor  '(box "#00ff00")
        evil-insert-state-cursor  '(box "#00ff00")
        evil-visual-state-cursor  '(box "#00ff00")
        evil-replace-state-cursor '(box "#00ff00")
        evil-motion-state-cursor  '(box "#00ff00")
        evil-emacs-state-cursor   '(box "#00ff00")))

(use-package ein
  :ensure t
  :defer t
  :config
  (evil-leader/set-key "jb" #'ein:jupyter-server-start))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
