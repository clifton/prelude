;; paredit settings
(prelude-require-package 'paredit)

;; turn on autocomplete globally
(global-auto-complete-mode t)
(setq ac-comphist-file "~/.emacs.d/personal/ac-comphist.dat")

;; turn on eldoc mode for all lisps
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

;; use CtrlP style find-in-project
(setq projectile-completion-system 'grizzl)

;; turn on paredit mode for clojure
(require 'paredit)
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(define-key paredit-mode-map (kbd "M-;") 'comment-or-uncomment-region-or-line)

;; Ruby mode files
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
