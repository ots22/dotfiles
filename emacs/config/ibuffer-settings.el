(setq ibuffer-saved-filter-groups
      (quote (("default"
	       ("shell" (mode . shell-mode))
	       ("dired" (mode . dired-mode))
	       ("org"   (mode . org-mode))
	       ("emacs" (or (filename . ".emacs$")
			    (name . "^\\*scratch\\*$")
			    (name . "^\\*Messages\\*$")))))))

(add-hook 'ibuffer-mode-hook
	  (lambda () (ibuffer-switch-to-saved-filter-groups "default")))
