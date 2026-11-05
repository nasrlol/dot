;;; nasr-blog.el --- portfolio post template -*- lexical-binding: t; -*-

;; Posts in ~/dev/portfolio/posts/*.org are built by build.sh, which needs
;; #+TITLE and #+DATE: YYYY-MM-DD. Opening a new (nonexistent) .org file
;; there inserts that header; M-x nasr/new-post creates one from a title.

(defconst nasr/blog-posts-dir (expand-file-name "~/dev/portfolio/posts/"))

(defun nasr/blog-header (title)
  "Return the post header text for TITLE, dated today."
  (concat "#+TITLE: " title "\n"
          "#+DATE: " (format-time-string "%Y-%m-%d") "\n\n"))

(defun nasr/blog-insert-header ()
  "Insert the post header into a new, empty post file."
  (when (and buffer-file-name
             (string-prefix-p nasr/blog-posts-dir buffer-file-name)
             (string-suffix-p ".org" buffer-file-name)
             (not (file-exists-p buffer-file-name))
             (= (buffer-size) 0))
    (insert (nasr/blog-header (file-name-base buffer-file-name)))))

(add-hook 'find-file-hook #'nasr/blog-insert-header)

(defun nasr/new-post (title)
  "Open a new portfolio post named TITLE, with the header filled in."
  (interactive "sPost title: ")
  (find-file (expand-file-name (concat title ".org") nasr/blog-posts-dir)))

;; Unlike the other two, this works in any buffer, new post or not.
(defun nasr/insert-post-header (title)
  "Insert the post header for TITLE at the top of the current buffer.
TITLE defaults to the file name."
  (interactive
   (let ((default (if buffer-file-name (file-name-base buffer-file-name) "")))
     (list (read-string (format "Post title (default %s): " default)
                        nil nil default))))
  (save-excursion
    (goto-char (point-min))
    (insert (nasr/blog-header title))))

;;; nasr-blog.el ends here
