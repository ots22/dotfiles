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

(add-to-list 'load-path "~/.emacs.d/site-lisp/")

(add-to-list 'load-path "~/.emacs.d/config/")
(load-library "modes")
(load-library "package-config")
(load-library "shell-tramp-config")
(load-library "misc")
(load-library "ibuffer-settings")
(load-library "backup")
(load-library "keys")

;; commented-out "package-initialize" to placate package.el (it's
;; actually called in package-config.el:
;; (package-initialize)

(setq custom-file "~/.emacs.d/config/custom.el")
(load custom-file)
