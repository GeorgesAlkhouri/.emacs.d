;;; init-dev.el --- development settings for init file


;;; Commentary:
;; Evaluated when loading init file.
;; Cleaner to keep this in a separate file rather than a long single line at the top of init.org

;;; Code:
(auto-tangle-mode)
(add-hook 'auto-tangle-before-tangle-hook #'check-parens)
(add-hook 'auto-tangle-after-tangle-hook (lambda () (load-file "~/.emacs.d/init.el")))
(eldoc-mode)
(provide 'init-dev)
