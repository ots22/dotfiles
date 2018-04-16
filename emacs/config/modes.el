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
