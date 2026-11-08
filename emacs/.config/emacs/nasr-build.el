;; -*- lexical-binding: t; -*-
;; Report every finished `compile' / `project-compile' to waybar's build
;; module, the same way ~/.local/bin/build-notify does for 4coder: write
;; "status<TAB>project<TAB>seconds<TAB>first error" to
;; ~/.local/state/build/last, the output to .../build/log, and send RTMIN+9
;; so the module refreshes right away. grep/rg buffers are skipped.

(require 'compile)

(defvar nasr/build-state-dir
  (expand-file-name "build" (or (getenv "XDG_STATE_HOME") "~/.local/state")))

(defvar-local nasr/build-start nil
  "When the compilation in this buffer started.")

(defun nasr/build--start (proc)
  (with-current-buffer (process-buffer proc)
    (setq nasr/build-start (current-time))))

(defun nasr/build--project ()
  (let ((root (or (when-let ((pr (project-current nil))) (project-root pr))
                  default-directory)))
    (file-name-nondirectory (directory-file-name (expand-file-name root)))))

(defun nasr/build--finish (buffer msg)
  (with-current-buffer buffer
    (unless (derived-mode-p 'grep-mode)
      (let* ((status (cond ((string-prefix-p "finished" msg) "0")
                           ((string-match "exited abnormally with code \\([0-9]+\\)" msg)
                            (match-string 1 msg))
                           (t "1")))
             (secs (if nasr/build-start
                       (format "%.2f" (float-time (time-since nasr/build-start)))
                     "0.00"))
             (err (save-excursion
                    (goto-char (point-min))
                    (if (re-search-forward
                         "^.*:[0-9]+\\(:[0-9]+\\)?: \\(fatal \\)?error:.*$" nil t)
                        (match-string-no-properties 0)
                      "")))
             (log (buffer-substring-no-properties (point-min) (point-max))))
        (make-directory nasr/build-state-dir t)
        (with-temp-file (expand-file-name "log" nasr/build-state-dir)
          (insert log))
        (with-temp-file (expand-file-name "last" nasr/build-state-dir)
          (insert (format "%s\t%s\t%s\t%s\n"
                          status (nasr/build--project) secs
                          (replace-regexp-in-string "[\t\n]" " " err))))
        (call-process "pkill" nil 0 nil "-RTMIN+9" "-x" "waybar")))))

(add-hook 'compilation-start-hook #'nasr/build--start)
(add-hook 'compilation-finish-functions #'nasr/build--finish)
