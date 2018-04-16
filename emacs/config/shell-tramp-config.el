(require 'tramp)

(set-variable 'dirtrack-list '(":\\(.*\\)\\$" 1 nil))

(add-hook 'shell-mode-hook #'(lambda () (dirtrack-mode 1)))

;; dir tracking on remote files
(set (make-local-variable 'comint-file-name-prefix)
     (or (file-remote-p default-directory) ""))

(defun set-exec-path-from-shell-path ()
  "Set up Emacs' `exec-path' and PATH environment variable to
match that used by the user's shell.  This is particularly useful
under Mac OSX, where GUI apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$" ""
			  (shell-command-to-string
			   "$SHELL --login -i -c 'echo $PATH' 2>/dev/null")))
	(ldpath-from-shell (replace-regexp-in-string
			    "[ \t\n]*$" ""
			    (shell-command-to-string
			     "$SHELL --login -i -c 'echo $LD_LIBRARY_PATH' 2>/dev/null"))))
    (setenv "PATH" path-from-shell)
    (setenv "LD_LIBRARY_PATH" ldpath-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(setenv "TMPDIR" "/tmp")
(setenv "BASH_ENV" "$HOME/.bashrc")

(set-exec-path-from-shell-path)

(setq tramp-default-method "ssh")
(setq tramp-encoding-shell "bash")

;;; this was needed to get e.g. compile to work properly.  Otherwise
;;; it doesn't see the correct PATH.
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)
