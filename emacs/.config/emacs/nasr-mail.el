;;; nasr-mail.el --- Mail: mu4e + mbsync + msmtp -*- lexical-binding: t; -*-

;; nasr@nsrddyn.com on mail.nsrddyn.com (valencia):
;;   - mbsync pulls IMAP into ~/Mail/nsrddyn   (~/.config/isyncrc)
;;   - mu indexes it, mu4e is the UI           (C-c m)
;;   - msmtp sends through port 587            (~/.config/msmtp/config)
;;   - subscribe to lists as nasr+lists@nsrddyn.com; they show under b l
;; Password lives in the keyring, shared by mbsync and msmtp:
;;   secret-tool store --label="Mail nsrddyn.com" service mail host mail.nsrddyn.com user nasr
;; One-time:  mbsync nsrddyn && mu init --maildir ~/Mail/nsrddyn --my-address nasr@nsrddyn.com && mu index

(use-package mu4e
  :ensure nil                                      ; from net-mail/mu[emacs]
  :load-path "/usr/share/emacs/site-lisp/mu4e"
  :commands mu4e
  :bind ("C-c m" . mu4e)
  :init
  (setq user-full-name "nasr"
        user-mail-address "nasr@nsrddyn.com")
  :config
  (setq mu4e-get-mail-command "mbsync nsrddyn"
        mu4e-update-interval 300
        mu4e-change-filenames-when-moving t          ; required with mbsync
        mu4e-confirm-quit nil
        mu4e-context-policy 'pick-first

        ;; folders (relative to ~/Mail/nsrddyn)
        mu4e-sent-folder   "/Sent"
        mu4e-drafts-folder "/Drafts"
        mu4e-trash-folder  "/Trash"
        mu4e-refile-folder "/Archive"
        mu4e-sent-messages-behavior 'sent            ; server does not save sent mail itself
        mu4e-maildir-shortcuts
        '((:maildir "/INBOX"   :key ?i)
          (:maildir "/Sent"    :key ?s)
          (:maildir "/Archive" :key ?a)
          (:maildir "/Junk"    :key ?j)
          (:maildir "/Trash"   :key ?t))

        ;; bookmarks (b <key>): mailing lists stay out of Inbox/Unread
        mu4e-bookmarks
        '((:name "Inbox"  :query "maildir:/INBOX AND NOT list:/.+/" :key ?i)
          (:name "Unread" :query "flag:unread AND NOT flag:trashed AND NOT list:/.+/" :key ?u)
          (:name "Lists"  :query "list:/.+/ AND NOT flag:trashed" :key ?l)
          (:name "Today"  :query "date:today..now AND NOT list:/.+/" :key ?t))

        ;; reading
        mu4e-view-show-addresses t
        mu4e-headers-date-format "%Y-%m-%d"
        mu4e-compose-format-flowed t)

  ;; one bookmark per mailing list, found from the List-Id headers mu has indexed;
  ;; runs before the mu server starts, so new lists show up on the next mu4e launch
  (defun nasr/mu4e-list-bookmarks ()
    (let* ((ids (seq-uniq
                 (seq-remove (lambda (id) (string-match-p "example\\.org\\'" id))
                             (ignore-errors
                               (process-lines "mu" "find" "list:/.+/" "--fields" "v")))))
           (ids (sort ids (lambda (a b)
                            (string< (nasr/mu4e-list-name a) (nasr/mu4e-list-name b)))))
           (used (mapcar (lambda (bm) (plist-get bm :key)) mu4e-bookmarks))
           (keys (seq-remove (lambda (k) (memq k used))
                             (string-to-list "abcdefghjkmnopqrsvwxyz0123456789"))))
      (seq-mapn (lambda (id key)
                  (list :name (concat "  " (nasr/mu4e-list-name id))
                        :query (format "list:%s AND NOT flag:trashed" id)
                        :key key))
                ids keys)))

  (defun nasr/mu4e-list-name (id)
    "rust-for-linux.vger.kernel.org -> rust-for-linux, ~mpu/qbe.lists.sr.ht -> qbe."
    (car (split-string (file-name-nondirectory id) "\\.")))

  (setq mu4e-bookmarks (append mu4e-bookmarks (nasr/mu4e-list-bookmarks)))

  ;; sending through msmtp
  (setq send-mail-function 'message-send-mail-with-sendmail
        message-send-mail-function 'message-send-mail-with-sendmail
        sendmail-program (executable-find "msmtp")
        message-sendmail-envelope-from 'header
        mail-specify-envelope-from t
        mail-envelope-from 'header
        message-kill-buffer-on-exit t)

  (with-eval-after-load 'evil-collection
    (evil-collection-init 'mu4e)))
