(prelude-require-packages '(ac-slime))

(setq slime-default-lisp 'sbcl)
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq slime-lisp-implementations
      '((sbcl ("sbcl" "--noinform") :coding-system utf-8-unix)))

(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-mode-hook 'turn-on-eldoc-mode)
(add-hook 'slime-mode-hook 'start-slime)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))

(eval-after-load "slime"
  '(progn
     (setq slime-fuzzy-completion-in-place t
           slime-enable-evaluate-in-emacs t
           slime-autodoc-use-multiline-p t)

     (define-key slime-mode-map (kbd "TAB") 'slime-indent-and-complete-symbol)
     (define-key slime-mode-map (kbd "C-c i") 'slime-inspect)
     (define-key slime-mode-map (kbd "C-c C-s") 'slime-selector)))

(defun start-slime ()
  "Start SLIME unless it's already running."
  (unless (slime-connected-p)
    (save-excursion (slime))))
