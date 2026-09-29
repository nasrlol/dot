;;; early-init.el -*- lexical-binding: t; -*-

;; Keep generated state out of the config dir (which is a git repo).
(defconst nasr/data-dir  (expand-file-name "emacs/" (or (getenv "XDG_DATA_HOME") "~/.local/share/")))
(defconst nasr/cache-dir (expand-file-name "emacs/" (or (getenv "XDG_CACHE_HOME") "~/.cache/")))

(when (and (fboundp 'native-comp-available-p) (native-comp-available-p))
  (startup-redirect-eln-cache (expand-file-name "eln-cache/" nasr/cache-dir)))

(setq package-user-dir (expand-file-name "elpa/" nasr/data-dir))
