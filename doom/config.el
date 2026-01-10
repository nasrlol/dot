;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; (setq user-full-name "Abdellah El Morabit"
;;       user-mail-address "nsrddyn@gmail.com")

;;; UI Configuration

;; Font (matching your Neovim: LiterationMono Nerd Font h9)
(setq doom-font (font-spec :family "LiterationMono Nerd Font" :size 12)
      doom-variable-pitch-font (font-spec :family "LiterationMono Nerd Font" :size 12))

;; Theme
(setq doom-theme 'doom-one)

;; Line numbers
(setq display-line-numbers-type t)

;; Scrolling (matching scrolloff=18, sidescrolloff=18)
(setq scroll-margin 18
      scroll-conservatively 101
      scroll-preserve-screen-position t
      hscroll-margin 18
      hscroll-step 1)

;; No mouse (matching mouse = "")
(when (display-graphic-p)
  (xterm-mouse-mode -1)
  (dolist (k '([mouse-1] [down-mouse-1] [drag-mouse-1] [double-mouse-1] [triple-mouse-1]
               [mouse-2] [down-mouse-2] [drag-mouse-2] [double-mouse-2] [triple-mouse-2]
               [mouse-3] [down-mouse-3] [drag-mouse-3] [double-mouse-3] [triple-mouse-3]
               [mouse-4] [down-mouse-4] [drag-mouse-4] [double-mouse-4] [triple-mouse-4]
               [mouse-5] [down-mouse-5] [drag-mouse-5] [double-mouse-5] [triple-mouse-5]))
    (global-unset-key k)))

;;; Editor Behavior

;; Tab settings (matching tabstop=2, shiftwidth=2, expandtab=true)
(setq-default tab-width 2
              evil-shift-width 2
              indent-tabs-mode nil
              tab-always-indent t)

;; Splits (matching splitright=true, splitbelow=true)
(setq evil-split-window-below t
      evil-vsplit-window-right t
      split-width-threshold 160
      split-height-threshold nil)

;; Line wrapping (matching wrap=false)
(setq-default truncate-lines t)

;; Search (matching ignorecase=true, smartcase=true)
(setq case-fold-search t)
(after! evil
  (setq evil-ex-search-case 'smart))

;; Join spaces (matching joinspaces=false)
(setq sentence-end-double-space nil)

;; Better undo
(setq evil-want-fine-undo t)

;; Clipboard (matching clipboard=unnamedplus)
(setq select-enable-clipboard t
      select-enable-primary t)

;; Disable quit confirmation
(setq confirm-kill-emacs nil)

;; Update time (matching updatetime=400)
(setq idle-update-delay 0.4)

;; Completion (matching completeopt)
(after! corfu
  (setq corfu-auto t
        corfu-auto-delay 0.1
        corfu-auto-prefix 2
        corfu-quit-at-boundary 'separator
        corfu-quit-no-match t))

;;; Keybindings

;; Disable arrow keys (matching your nvim config)
(map! :nv "<up>" nil
      :nv "<down>" nil
      :nv "<left>" nil
      :nv "<right>" nil
      :i "<up>" nil
      :i "<down>" nil
      :i "<left>" nil
      :i "<right>" nil)

;; Disable q: q/ q? (command-line window)
(map! :n "q:" nil
      :n "q/" nil
      :n "q?" nil)

;; Visual line movement (j/k move by visual lines)
(map! :nv "j" #'evil-next-visual-line
      :nv "k" #'evil-previous-visual-line)

;; Visual mode paste without yanking (matching <leader>p)
(map! :v "p" "\"_dP")

;; Leader keybindings
(map! :leader
      ;; File operations
      :desc "Save file" "w" #'save-buffer
      :desc "Reload config" "s" (lambda () (interactive) (load-file (concat doom-user-dir "config.el")))
      :desc "Quit" "q" #'evil-quit

      ;; Yank entire buffer
      :desc "Yank buffer" "y b" (lambda () (interactive)
                                   (clipboard-kill-ring-save (point-min) (point-max))
                                   (message "Buffer copied to clipboard"))

      ;; Hex mode (changed from "h e x" to avoid conflict)
      :desc "Hex mode" "x h" #'hexl-mode

      ;; File finder (fzf-lua equivalents)
      :desc "Find file" "f f" #'find-file
      :desc "Find in project" "f a" #'+default/search-project
      :desc "Git files" "g f" #'magit-find-file
      :desc "Colorschemes" "c s" #'consult-theme

      ;; Treesitter/Imenu
      :desc "Symbols" "t s" #'consult-imenu

      ;; Buffer management
      :desc "Next buffer" "b n" #'next-buffer
      :desc "Previous buffer" "b p" #'previous-buffer
      :desc "Last buffer" "b b" #'evil-switch-to-windows-last-buffer
      :desc "Close buffer" "b c" #'kill-current-buffer

      ;; File explorer (Oil.nvim → Dired)
      :desc "File explorer" "e x" #'dired-jump

      ;; Terminal
      :desc "Terminal" "t t" #'+vterm/toggle

      ;; Toggle whitespace characters (matching <leader>-)
      :desc "Toggle whitespace" "-" #'whitespace-mode)

;; LSP keybindings (matching your nvim lsp config)
(map! :map (prog-mode-map text-mode-map)
      :n "g d" #'lsp-find-definition
      :n "g r" #'lsp-find-references
      :n "K" #'lsp-describe-thing-at-point)

(map! :leader
      :desc "Code action" "c a" #'lsp-execute-code-action
      :desc "Rename symbol" "r n" #'lsp-rename
      :desc "Show diagnostic" "o r" #'lsp-ui-doc-show
      :desc "Next diagnostic" "n r" #'flycheck-next-error
      :desc "Workspace diagnostics" "r r" #'consult-flycheck)

;; Terminal escape (matching <Esc><Esc> in term mode)
(map! :map vterm-mode-map
      :i "<escape><escape>" #'vterm--self-insert)

;;; Build System (matching your <leader>t and <leader>tf)

(after! compile
  ;; Set compilation window to open on the right side
  (setf (alist-get "\\*compilation\\*" display-buffer-alist nil nil #'equal)
        '((display-buffer-reuse-window
           display-buffer-in-side-window)
          (side . right)
          (slot . 0)
          (window-width . 0.4)
          (inhibit-same-window . t))))

(defun appie/get-build-command ()
  "Get build command - use build.sh if exists, otherwise default cc command."
  (let ((build-script (concat default-directory "build.sh")))
    (if (file-exists-p build-script)
        (format "sh %s" build-script)
      "cc -std=c11 -Wall -Wextra -Werror -g *.c -o a.out")))

(defun appie/build ()
  "Build project using build.sh or default cc command."
  (interactive)
  (let ((compile-command (appie/get-build-command)))
    (save-some-buffers t)
    (compile compile-command)))

(defun appie/build-floating ()
  "Build project and show output in floating window."
  (interactive)
  (let ((compile-command (appie/get-build-command)))
    (save-some-buffers t)
    (let ((output-buffer (get-buffer-create "*build-output*"))
          (process-environment (cons "TERM=dumb" process-environment)))
      (with-current-buffer output-buffer
        (erase-buffer)
        (setq buffer-read-only nil))
      
      (set-process-sentinel
       (start-process-shell-command "build" output-buffer compile-command)
       (lambda (process event)
         (when (string-match-p "finished\\|exited" event)
           (with-current-buffer (process-buffer process)
             (goto-char (point-min))
             (when (> (buffer-size) 0)
               (let* ((content (buffer-string))
                      (lines (split-string content "\n"))
                      (line-count (length lines))
                      (width (floor (* (frame-width) 0.7)))
                      (height (min (+ line-count 2) (floor (* (frame-height) 0.5)))))
                 (pop-to-buffer (current-buffer)
                                `((display-buffer-in-side-window)
                                  (side . bottom)
                                  (window-height . ,height)
                                  (slot . 0)))
                 (setq buffer-read-only t)
                 (local-set-key (kbd "q") 'quit-window))))))))))

(map! :leader
      :prefix ("t" . "test/build")
      :desc "Build (quickfix)" "t" #'appie/build
      :desc "Build (floating)" "f" #'appie/build-floating)

;; Optional: F5 for quick build (Casey Muratori style)
(map! "<f5>" #'appie/build)

;;; LSP Configuration

(after! lsp-mode
  ;; Performance tuning
  (setq lsp-idle-delay 0.5
        lsp-log-io nil
        lsp-enable-file-watchers t
        lsp-file-watch-threshold 5000)
  
  ;; UI elements
  (setq lsp-headerline-breadcrumb-enable nil
        lsp-lens-enable nil
        lsp-modeline-code-actions-enable t
        lsp-signature-auto-activate t
        lsp-signature-render-documentation t)
  
  ;; Diagnostics
  (setq lsp-diagnostics-provider :flycheck
        lsp-ui-doc-enable t
        lsp-ui-doc-show-with-cursor nil
        lsp-ui-doc-show-with-mouse t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-max-width 160
        lsp-ui-doc-max-height 50))

;; Gopls configuration
(after! lsp-go
  (setq lsp-go-use-gofumpt t
        lsp-go-analyses '((shadow . t)
                          (simplifycompositelit . t))))

;; Clangd configuration  
(after! lsp-clangd
  (setq lsp-clients-clangd-args
        '("--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=never"
          "--header-insertion-decorators=0")))

;;; Dired Configuration (Oil.nvim equivalent)

(after! dired
  (setq dired-listing-switches "-alh --group-directories-first"
        dired-omit-files "^\\.?#\\|^\\.$"
        dired-kill-when-opening-new-dired-buffer t
        dired-clean-confirm-killing-deleted-buffers t
        dired-dwim-target t)
  
  ;; Auto-refresh dired
  (add-hook 'dired-mode-hook 'auto-revert-mode)
  
  ;; Dired keybindings (matching Oil.nvim)
  (map! :map dired-mode-map
        :n "q" #'quit-window
        :n "-" #'dired-up-directory
        :n "RET" #'dired-find-file
        :n "g." #'dired-hide-dotfiles-mode))

;;; Whitespace Mode Configuration

(after! whitespace
  (setq whitespace-style '(face tabs spaces trailing space-before-tab
                           newline indentation empty space-after-tab
                           space-mark tab-mark)
        whitespace-display-mappings
        '((space-mark   32 [183] [46])       ; · 
          (newline-mark 10 [182 10])          ; ¶
          (tab-mark      9 [187 9] [92 9])))) ; »

;;; Miscellaneous

;; Org directory
(setq org-directory "~/org/")

;; Grep with ripgrep (matching grepprg)
(when (executable-find "rg")
  (setq grep-program "rg"
        grep-command "rg --vimgrep --smart-case --hidden "))

;; Treesitter (when available)
(setq treesit-font-lock-level 4)

;; Disable format-on-save globally (you didn't have it in nvim)
(remove-hook 'before-save-hook #'+format|buffer-h)

;; Transparency (matching your transparent background)
(add-to-list 'default-frame-alist '(alpha-background . 100))

;;; config.el ends here
