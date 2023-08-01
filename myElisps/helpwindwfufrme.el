;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with C-x C-f and enter text in its buffer.

(defmacro help-window-full-frame (buffer-name &rest body)
"Doc-string."
  (declare (indent 1) (debug t))
  `(progn
    (set-marker help-window-point-marker nil)
      (let* (
          (help-window-select t)
          (foo
            (lambda ()
              (set (make-local-variable 'window-configuration)
                (current-window-configuration))
              (local-set-key "q"
                (lambda ()
                  (interactive)
                  (when window-configuration
                    ;; Record the `current-buffer' before it gets buried.
                    (let ((cb (current-buffer)))
                      (set-window-configuration window-configuration)
                      (kill-buffer cb)))))))
          ;; Preserve the original hook values by let-binding them in advance.
          ;; Otherwise, `add-to-list' would alter the global value.
          (temp-buffer-window-setup-hook temp-buffer-window-setup-hook)
          (temp-buffer-window-show-hook temp-buffer-window-show-hook)
          (temp-buffer-window-setup-hook
            (cond
              ((null temp-buffer-window-setup-hook)
                (list 'help-mode-setup foo))
              ((and
                  (not (null temp-buffer-window-setup-hook))
                  (listp temp-buffer-window-setup-hook))
                (add-to-list 'temp-buffer-window-setup-hook foo)
                (add-to-list 'temp-buffer-window-setup-hook 'help-mode-setup))
              ((and
                  (not (null temp-buffer-window-setup-hook))
                  (symbolp temp-buffer-window-setup-hook))
                (list 'help-mode-setup foo temp-buffer-window-setup-hook))))
          (temp-buffer-window-show-hook
            (cond
              ((null temp-buffer-window-show-hook)
                (list 'help-mode-finish 'delete-other-windows))
              ((and
                  (not (null temp-buffer-window-show-hook))
                  (listp temp-buffer-window-show-hook))
                (add-to-list 'temp-buffer-window-show-hook 'delete-other-windows)
                (add-to-list 'temp-buffer-window-show-hook 'help-mode-finish))
              ((and
                  (not (null temp-buffer-window-show-hook))
                  (symbolp temp-buffer-window-show-hook))
                (list
                  'help-mode-finish
                  'delete-other-windows
                  temp-buffer-window-show-hook)))) )
        (with-temp-buffer-window ,buffer-name nil 'help-window-setup (progn ,@body)))))

;;(help-window-full-frame (help-buffer)
;;  (princ "Type q to kill this *Help* buffer and restore prior window configuration."))
