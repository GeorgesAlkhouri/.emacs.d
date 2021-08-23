;; -*- lexical-binding: t; -*-

(setq straight-repository-branch "develop")
(setq straight-check-for-modifications '(watch-files))
(setq straight-use-package-by-default t)
(setq straight-vc-git-default-protocol 'https)
(setq straight-vc-git-force-protocol nil)
(defvar bootstrap-version)
(setq straight-host-usernames '((github . "progfolio")
                                (gitlab . "iarchivedmywholelife")))
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'keychain-environment)
(require 'keychain-environment)
(keychain-refresh-environment)
(setq straight-vc-git-default-protocol 'ssh)

(straight-use-package 'org-contrib)

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs loaded in %s with %d garbage collecitons."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(defmacro use-feature (name &rest args)
  "Like `use-package' but with `straight-use-package-by-default' disabled.
NAME and ARGS are in `use-package'."
  (declare (indent defun))
  `(use-package ,name
     :straight nil
     :ensure nil
     ,@args))

(straight-use-package 'use-package)
(eval-when-compile
  (require 'use-package))

(setq init-file-debug nil)
(if init-file-debug
    (setq use-package-verbose t
          use-package-expand-minimally nil
          use-package-compute-statistics t
          debug-on-error t)
  (setq use-package-verbose nil
        use-package-expand-minimally t))

(use-package evil
  :demand t
  :preface (setq evil-want-keybinding nil)
  :custom
  (evil-want-integration t)
  (evil-undo-system 'undo-redo)
  :hook (after-init . evil-mode))

(use-package evil-collection
  :after (evil)
  :config (evil-collection-init)
  :custom
  (evil-collection-setup-minibuffer t "Add evil bindings to minibuffer")
)

(use-package general
  :demand t)

(general-create-definer global-definer
  :keymaps 'override
  :states  '(normal)
  :prefix  "SPC"
  )

(global-definer
  "!"   'shell-command
  ":"   'eval-expression
  "TAB" '((lambda () (interactive) (switch-to-buffer nil))
      :which-key "other-buffer")
)

(general-create-definer global-leader
  :keymaps 'override
  :states '(normal)
  :prefix "SPC m"
  :non-normal-prefix "C-SPC m"
  "" '( :ignore t
        :which-key
        (lambda (arg)
          (cons (cadr (split-string (car arg) " "))
                (replace-regexp-in-string "-mode$" "" (symbol-name major-mode))))))

(defmacro +general-global-menu! (name infix-key &rest body)
  "Create a definer named +general-global-NAME wrapping global-definer.
Create prefix map: +general-global-NAME. Prefix bindings in BODY with INFIX-KEY."
  (declare (indent 2))
  `(progn
     (general-create-definer ,(intern (concat "+general-global-" name))
       :wrapping global-definer
       :prefix-map (quote ,(intern (concat "+general-global-" name "-map")))
       :infix ,infix-key
       :wk-full-keys nil
       "" '(:ignore t :which-key ,name))
     (,(intern (concat "+general-global-" name))
      ,@body)))

(+general-global-menu! "application" "a")

(+general-global-menu! "buffer" "b"
  "d"  'kill-current-buffer
  "o" '((lambda () (interactive) (switch-to-buffer nil))
        :which-key "other-buffer")
  "p"  'previous-buffer
  "r"  'rename-buffer
  "R"  'revert-buffer
  "M" '((lambda () (interactive) (switch-to-buffer "*Messages*"))
        :which-key "messages-buffer")
  "n"  'next-buffer
  "s" '((lambda () (interactive) (switch-to-buffer "*scratch*"))
        :which-key "scratch-buffer")
)

(+general-global-menu! "jump" "j"
  )

(+general-global-menu! "file" "f"
  )

(+general-global-menu! "git" "g")

(+general-global-menu! "window" "w"
  "?" 'split-window-vertically
  "=" 'balance-windows-area
  "/" 'split-window-horizontally
  "O" 'delete-other-windows
  "X" '((lambda () (interactive) (call-interactively #'other-window) (kill-buffer-and-window))
        :which-key "kill-other-buffer-and-window")
  "H" 'evil-window-move-far-left
  "J" 'evil-window-move-very-bottom
  "K" 'evil-window-move-very-top
  "L" 'evil-window-move-far-right
  "d" 'delete-window
  "h" 'windmove-left
  "j" 'windmove-down
  "k" 'windmove-up
  "l" 'windmove-right
  "o" 'other-window
  "t" '((lambda () (interactive)
          "toggle window dedication"
          (set-window-dedicated-p (selected-window) (not (window-dedicated-p))))
        :which-key "toggle window dedication")
  "x" 'kill-buffer-and-window)

(+general-global-menu! "project" "p"
  "b" '(:ignore t :which-key "buffer"))

(use-package which-key
  :demand t
  :init
  (setq which-key-enable-extended-define-key t)
  :config
  (which-key-mode)
  :custom
  (which-key-side-window-location 'bottom)
  (which-key-sort-order 'which-key-key-order-alpha)
  (which-key-side-window-max-width 0.33)
  (which-key-idle-delay 0.05)
  :diminish which-key-mode)

(use-package magit
  :defer t
  :after (general)
  :general
  (+general-global-git
      "b"  'magit-blame
      "i"  'magit-init
      "s"  'magit-status)
  :init
  :config
  (transient-bind-q-to-quit))

(use-package helm
:init (require 'helm-config)
:defer 1
:config
(add-hook 'helm-after-initialize-hook (lambda () (with-helm-buffer (visual-line-mode))))
(helm-mode)
:general
(:keymaps 'helm-map
          "TAB"   #'helm-execute-persistent-action
          "<tab>" #'helm-execute-persistent-action
          "C-a"   #'helm-select-action
          "C-h"   #'helm-find-files-up-one-level
          "C-j"   #'helm-next-line
          "C-k"   #'helm-previous-line)
(global-definer
  "SPC" '(helm-M-x :which-key "M-x")
  "/"   'helm-occur)
(+general-global-file
"f" 'helm-find-files
"F" 'helm-find
"r" 'helm-recentf)
(+general-global-buffer
  "b" 'helm-mini)
(+general-global-jump
    "i" 'helm-imenu))

(use-package helm-projectile
  :after (helm)
  :general
  (+general-global-project
    "d" 'helm-projectile-find-dir
    "f" 'helm-projectile-find-file
    "p" 'helm-projectile-switch-project
    "r" 'helm-projectile-recentf))

(use-package projectile
  :after (general)
  :general
  (+general-global-project
    "!" 'projectile-run-shell-command-in-root
    "%" 'projectile-replace-regexp
    "D" 'projectile-dired
    "e" 'projectile-edit-dir-locals
    "g" 'projectile-find-tag
    "G" 'projectile-regenerate-tags
    "R" 'projectile-replace
    "v" 'projectile-vc)
  :config
  (projectile-mode))

(use-package vterm
  :straight (:post-build (cl-letf (((symbol-function #'pop-to-buffer)
                                    (lambda (buffer) (with-current-buffer buffer (message (buffer-string))))))
                           (setq vterm-always-compile-module t)
                           (require 'vterm)))
  :commands (vterm vterm-other-window)
  :general
  (+general-global-application
    "t" '(:ignore t :which-key "terminal")
    "tt" 'vterm-other-window
    "t." 'vterm)
  :config
  (evil-set-initial-state 'vterm-mode 'emacs))
