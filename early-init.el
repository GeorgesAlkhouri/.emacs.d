;;; early-init.el --- Emacs pre package.el & GUI configuration -*- lexical-binding: t; -*-
;;; Code:

(when-let (orglib (locate-library "org" nil load-path))
  (setq-default load-path (delete (substring (file-name-directory orglib) 0 -1)
                                  load-path)))

(setq package-enable-at-startup nil)

(defvar default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq gc-cons-threshold most-positive-fixnum)

(defun +gc-after-focus-change ()
  "Run GC when frame loses focus."
  (run-with-idle-timer
   5 nil
   (lambda () (unless (frame-focus-state) (garbage-collect)))))

(defun +reset-init-values ()
  (run-with-idle-timer
   5 nil
   (lambda ()
     (setq file-name-handler-alist default-file-name-handler-alist
           gc-cons-threshold 100000000)
     (message "gc-cons-threshold & file-name-handler-alist restored")
     (when (boundp 'after-focus-change-function)
       (add-function :after after-focus-change-function #'+gc-after-focus-change)))))

(add-hook 'emacs-startup-hook '+reset-init-values)

(setq read-process-output-max (* 1024 1024)) ;; 1mb

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(setq frame-inhibit-implied-resize t)

(push '(font . "Source Code Pro") default-frame-alist)
(set-face-font 'default "Source Code Pro")
(set-face-font 'variable-pitch "DejaVu Sans")
(copy-face 'default 'fixed-pitch)

(advice-add #'x-apply-session-resources :override #'ignore)

(setq desktop-restore-forces-onscreen nil)

(provide 'early-init)
;;; early-init.el ends here
