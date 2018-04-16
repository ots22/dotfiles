;; Initialize emacs package manager.  For older versions of emacs, it
;; is not installed by default
(when (functionp 'package-initialize)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package)))
