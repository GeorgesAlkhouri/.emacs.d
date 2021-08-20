(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(eval-when-compile
  (require 'use-package)
  )


(use-package evil
  :demand t
  :ensure t

;;  :custom
;;  (evil-esc-delay 0.001 "avoid ESC/meta mixups")
;;  (evil-shift-width 4)
;;  (evil-search-module 'evil-search)

;;  :bind (:map evil-normal-state-map
;;         ("S" . replace-symbol-at-point))

  :config
  ;; Enable evil-mode in all buffers.
  (evil-mode 1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(use-package helm evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
