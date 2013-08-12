;;; Clojure Settings

;; set up autocomplete
(prelude-require-package 'ac-nrepl)
(require 'ac-nrepl)
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
 (add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
 (eval-after-load "auto-complete"
   '(add-to-list 'ac-modes 'nrepl-mode))

(setq nrepl-hide-special-buffers t)

;; use tab for autocomplete
(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))
(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)

;; use popup documentation instead of creating a new frame
(define-key nrepl-interaction-mode-map (kbd "C-c C-d") 'ac-nrepl-popup-doc)

;; show function documentation in modeline
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)

;; enable paredit mode
(add-hook 'clojure-mode-hook #'enable-paredit-mode)
(add-hook 'nrepl-mode-hook   #'enable-paredit-mode)

;; display nrepl stacktraces inline
(setq nrepl-popup-stacktraces nil)
(setq nrepl-popup-stacktraces-in-repl t)

;; C-c C-z should switch to nrepl
(add-to-list 'same-window-buffer-names "*nrepl*")

;; edn & cljs are clojure
(setq auto-mode-alist (cons '("\\.edn$" . clojure-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cljs$" . clojure-mode) auto-mode-alist))
