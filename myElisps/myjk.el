;; Copied from the below link
;; https://emacs.stackexchange.com/questions/19961/using-jk-to-exit-insert-mode-with-key-chord-or-anything-else
(defun my-jk ()
  "Home made escape shortcut in evil mode"
  (interactive)
  (let* ((initial-key ?j)
         (final-key ?k)
         (timeout 0.5)
         (event (read-event nil nil timeout)))
    (if event
        ;; timeout met
        (if (and (characterp event) (= event final-key))
            (evil-normal-state)
          (insert initial-key)
          (push event unread-command-events))
      ;; timeout exceeded
      (insert initial-key))))

(define-key evil-insert-state-map (kbd "j") 'my-jk)
