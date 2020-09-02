(setq inhibit-splash-screen 1)
(setq initial-scratch-message nil)
(setq window-combination-resize t)
(if (functionp 'tool-bar-mode) (tool-bar-mode 0))
(if (functionp 'menu-bar-mode) (menu-bar-mode 0))
(if (functionp 'blink-cursor-mode) (blink-cursor-mode 0))
(global-font-lock-mode 1)
(column-number-mode 1)

(setq-default cursor-type 'box)

(put 'upcase-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(add-to-list 'load-path "~/.emacs.d/site-lisp/")


;;;;;;;;
;; Modes

(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.F90\\'" . f90-mode))

(autoload 'gnuplot-mode "gnuplot-mode" "" t)
(add-to-list 'auto-mode-alist '("\\.\\(gp|gnuplot|gnu\\)\\'" . gnuplot-mode))

(setq c-default-style
      '((java-mode . "java") (awk-mode . "awk") (other . "bsd")))

;; for whitespace mode:
(setq whitespace-style '(face trailing tab tab-mark space-before-tab))

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(add-hook 'tex-mode-hook 'ezbf-minor-mode)

(add-hook 'shell-mode-hook (lambda () (visual-line-mode 1)))

(require 'vc)
(add-hook 'after-save-hook
	  (lambda ()
	    "Commit the file to version control when the buffer is in org-mode"
	    (let ((fname (buffer-file-name)))
	      (when (and (eq major-mode 'org-mode)
			 (vc-registered fname))
		(vc-checkin (list fname)
			    (vc-backend fname)
			    (concat "Update " (file-name-nondirectory fname)))))))

(defun org-files-current-directory ()
    (directory-files default-directory t ".*.org"))

(setq org-refile-targets '((nil :maxlevel . 9) (org-files-current-directory :maxlevel . 9)))
(setq org-directory "~/shared/notes/")
(setq org-agenda-files '("~/shared/notes/"))

;(setq org-babel-noweb-wrap-begin "«")
;(setq org-babel-noweb-wrap-end "»")
(setq org-src-tab-acts-natively nil)
(setq org-src-fontify-natively t)
;(setq org-src-preserve-indentation t)


;;;;;;;;;;;;;;;;;
;; Package config

;; Initialize emacs package manager.  For older versions of emacs, it
;; is not installed by default
(when (functionp 'package-initialize)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package)))


;;;;;;;;;;;;;;;;;;;;;
;; Shell tramp config

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

;;(setq tramp-default-method "ssh")
(setq tramp-encoding-shell "bash")

;;; this was needed to get e.g. compile to work properly.  Otherwise
;;; it doesn't see the correct PATH.
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)

(setq tramp-verbose 10)

;;;;;;;;
;; Misc.

(defun smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(defun new-shell ()
  (interactive)
  (setq current-prefix-arg '(4))
  (call-interactively 'shell))

(defun my-date ()
  (interactive)
  (message (current-time-string)))

(defun filename-to-kill-ring ()
  "Put the filename of the current buffer on the kill ring.  In
dired mode, use the current directory"
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message filename))))

(defun increment-number-at-point ()
      (interactive)
      (skip-chars-backward "0-9")
      (or (looking-at "[0-9]+")
          (error "No number at point"))
      (replace-match (number-to-string (1+ (string-to-number (match-string 0))))))

;; Source: https://stackoverflow.com/a/37456354
(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let* ((name (buffer-name))
        (filename (buffer-file-name))
        (basename (file-name-nondirectory filename)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " (file-name-directory filename) basename nil basename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(defun next-page ()
  (interactive)
  (narrow-to-page 1))

(defun prev-page ()
  (interactive)
  (narrow-to-page -1))


;;;;;;;;;;;;;;;;;;;
;; ibuffer settings

(setq ibuffer-saved-filter-groups
      (quote (("default"
	       ("shell" (mode . shell-mode))
	       ("dired" (mode . dired-mode))
	       ("org"   (mode . org-mode))
	       ("sheep" (filename . "sheep"))
	       ("sargasso" (or (filename . "sargasso")
			       (filename . "sklad3")))
	       ("nocell" (filename . "nocell"))
	       ("wimbledon" (filename . "Wimbledon"))
	       ("emacs" (or (filename . ".emacs$")
			    ;(name . "^\\*scratch\\*$")
			    ;(name . "^\\*Messages\\*$")
			    (filename . ".el")
			    (name . "\\*.*\\*")))))))

(add-hook 'ibuffer-mode-hook
	  (lambda () (ibuffer-switch-to-saved-filter-groups "default")))


;;;;;;;;;
;; Backup

(setq backup-by-copying t)
(setq version-control t)
(setq vc-make-backup-files t)
(setq delete-old-versions t)
(setq kept-new-versions 10)
(setq kept-old-versions 2)
(setq make-backup-file-name-function 'make-backup-file-name)
(setq backup-directory-alist '(("" . "~/.backups/emacs")))


;;;;;;;
;; Keys

(global-set-key [f5] 'compile)
(global-set-key [f6] 'new-shell)
(global-set-key [f8] 'increment-number-at-point)
(global-set-key [f13] 'ibuffer)
(global-set-key [f19] 'my-date)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-S-v") 'scroll-other-window)
(global-set-key (kbd "M-V") 'scroll-other-window-down)
(global-set-key (kbd "M-o") 'smart-open-line-above)
(global-set-key (kbd "C-c f") 'filename-to-kill-ring)
(global-set-key (kbd "C-c n") 'next-page)
(global-set-key (kbd "C-c p") 'prev-page)
(global-set-key (kbd "C-<") (lambda () (interactive) (insert "«")))
(global-set-key (kbd "C->") (lambda () (interactive) (insert "»")))


;;;;;;;;;;;;
;; Customize

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(indent-tabs-mode nil)
 '(markdown-command "pandoc")
 '(org-agenda-files
   (quote
    ("~/projects/sargasso/report/notes.org" "/Users/ostrickson/shared/notes/autoderiv.org" "/Users/ostrickson/shared/notes/books.org" "/Users/ostrickson/shared/notes/emacs.org" "/Users/ostrickson/shared/notes/ideas.org" "/Users/ostrickson/shared/notes/racket.org" "/Users/ostrickson/shared/notes/sargasso.org")))
 '(package-selected-packages
   (quote
    (powershell ess yaml-mode ensime scala-mode racket-mode haskell-mode org helm-bibtex interleave use-package rainbow-delimiters rainbow-blocks matlab-mode markdown-mode+ julia-shell julia-repl cython-mode cmake-font-lock)))
 '(racket-program "/Applications/Racket v7.6/bin/racket")
 '(racket-smart-open-bracket-enable nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "White" :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 160 :width normal :foundry "nil" :family "Menlo")))))

;(setq custom-file "~/.emacs.d/config/custom.el")
;(load custom-file)

