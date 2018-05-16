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
