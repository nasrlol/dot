;;; nasr-keys.el --- 4coder bindings for evil -*- lexical-binding: t; -*-
;;
;; The core of /opt/4coder/build/4coder_byp/4coder_byp_bindings.cpp, so the
;; same hands work here. Normal state only, like 4coder's vim layer; SPC is
;; the leader there too.

(defun nasr/move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun nasr/move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(defun nasr/search-word ()
  "Search the project for the symbol at point (4coder search_identifier)."
  (interactive)
  (project-find-regexp (regexp-quote (thing-at-point 'symbol t))))

(defun nasr/format-buffer ()
  (interactive)
  (if (bound-and-true-p eglot--managed-mode)
      (eglot-format-buffer)
    (indent-region (point-min) (point-max))))

(defun nasr/save-all ()
  (interactive)
  (save-some-buffers t))

(with-eval-after-load 'evil
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-define-key 'normal 'global
    (kbd "M-p") #'switch-to-buffer
    (kbd "M-o") #'find-file
    (kbd "M-f") #'project-find-regexp
    (kbd "C-t") #'nasr/search-word
    (kbd "C-w") #'evil-goto-definition

    (kbd "M-v") #'split-window-right
    (kbd "M-h") #'split-window-below
    (kbd "M-q") #'delete-window

    (kbd "M-k") #'nasr/move-line-up
    (kbd "M-j") #'nasr/move-line-down

    (kbd "M-n") #'next-error
    (kbd "M-N") #'previous-error
    (kbd "M-M") #'first-error

    (kbd "M-b") #'project-compile
    (kbd "M-z") #'async-shell-command

    (kbd "C-<tab>") #'mode-line-other-buffer
    (kbd "C-S-s")   #'nasr/save-all

    (kbd "<leader>q") #'kill-current-buffer
    (kbd "<leader>f") #'imenu
    (kbd "<leader>k") #'nasr/format-buffer))

(provide 'nasr-keys)
