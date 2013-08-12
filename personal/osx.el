;; add mouse support in term
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode 1)
  (global-set-key [mouse-4] '(lambda ()
                               (interactive)
                               (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                               (interactive)
                               (scroll-up 1))))

;; disable menu bar when using prelude via term
(menu-bar-mode -1)

;; turn off scrollbars
(scroll-bar-mode -1)

;; prelude swaps super and meta by default, turn that off
(setq mac-command-modifier 'super)
(setq mac-option-modifier 'meta)
(setq ns-function-modifier 'hyper)
