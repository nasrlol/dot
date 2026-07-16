(defun my/c-mode-common-hook ()
  (c-set-style "awk")
  (setq
   indent-tabs-mode nil
   c-basic-offset 4))

(add-hook 'c-mode-common-hook 'my/c-mode-common-hook)

(defun open-directory-files (dir)
  "Open all files in DIR as separate buffers."
  (interactive "DDirectory: ")
  (let ((files (directory-files dir t "^[^.]" t)))
    (dolist (file files)
      (unless (file-directory-p file)
        (find-file file)))))

(defun open-directory-files-recursive (dir)
  "Open all files in DIR and subdirectories as separate buffers."
  (interactive "DDirectory: ")
  (let ((files (directory-files-recursively dir "^[^.]" nil)))
    (dolist (file files)
      (unless (file-directory-p file)
        (find-file file)))))
