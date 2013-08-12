;;; Bindings.el

;; find a useful key for navigating buffers
;; (define-key global-map (kbd "s-1") 'last-buffer-1)
(define-key global-map (kbd "M-;") 'comment-or-uncomment-region-or-line)
(define-key global-map (kbd "M-<return>") 'textmate-next-line)
(define-key global-map (kbd "M-S-<return>") 'textmate-previous-line)
(define-key global-map (kbd "M-p") 'move-up-eight)
(define-key global-map (kbd "M-n") 'move-down-eight)
(define-key global-map (kbd "M-T") 'textmate-goto-symbol)

;;; Projectile bindings
;; C-c p f	Display a list of all files in the project. With a prefix argument it will clear the cache first.
;; C-c p d	Display a list of all directories in the project. With a prefix argument it will clear the cache first.
;; C-c p T	Display a list of all test files(specs, features, etc) in the project.
;; C-c p g	Run grep on the files in the project.
;; C-c p b	Display a list of all project buffers currently open.
;; C-c p o	Runs multi-occur on all project buffers currently open.
;; C-c p r	Runs interactive query-replace on all files in the projects.
;; C-c p i	Invalidates the project cache (if existing).
;; C-c p R	Regenerates the projects TAGS file.
;; C-c p k	Kills all project buffers.
;; C-c p D	Opens the root of the project in dired.
;; C-c p e	Shows a list of recently visited project files.
;; C-c p a	Runs ack on the project. Requires the presence of ack-and-a-half.
;; C-c p c	Runs a standard compilation command for your type of project.
;; C-c p p	Runs a standard test command for your type of project.
;; C-c p z	Adds the currently visited to the cache.
;; C-c p s	Display a list of known projects you can switch to.

;; movement
(defun move-up-eight ()
  (interactive)
  (previous-line 8))

(defun move-down-eight ()
  (interactive)
  (next-line 8))

;; switch to last buffer
(defun last-buffer-1 ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

;; shamelessly stolen from defunkt
;; http://ozmm.org/posts/textmate_minor_mode.html
(defun textmate-next-line ()
  "Inserts an indented newline after the current line and moves the point to it."
  (interactive)
  (end-of-line)
  (newline-and-indent))

(defun textmate-previous-line ()
  "Inserts an indented newline before the current line and moves the point to it."
  (interactive)
  (previous-line)
  (end-of-line)
  (newline-and-indent))

;; http://stackoverflow.com/questions/9688748/emacs-comment-uncomment-current-line
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

;; http://chopmo.blogspot.com/2008/09/quickly-jumping-to-symbols.html
(defun textmate-goto-symbol ()
  "Update the imenu index and then use ido to select a symbol to navigate to.
Symbols matching the text at point are put first in the completion list."
  (interactive)
  (imenu--make-index-alist)
  (let ((name-and-pos '())
        (symbol-names '()))
    (flet ((addsymbols (symbol-list)
                       (when (listp symbol-list)
                         (dolist (symbol symbol-list)
                           (let ((name nil) (position nil))
                             (cond
                              ((and (listp symbol) (imenu--subalist-p symbol))
                               (addsymbols symbol))

                              ((listp symbol)
                               (setq name (car symbol))
                               (setq position (cdr symbol)))

                              ((stringp symbol)
                               (setq name symbol)
                               (setq position
                                     (get-text-property 1 'org-imenu-marker
                                                        symbol))))

                             (unless (or (null position) (null name))
                               (add-to-list 'symbol-names name)
                               (add-to-list 'name-and-pos (cons name position))))))))
      (addsymbols imenu--index-alist))
    ;; If there are matching symbols at point, put them at the beginning
    ;; of `symbol-names'.
    (let ((symbol-at-point (thing-at-point 'symbol)))
      (when symbol-at-point
        (let* ((regexp (concat (regexp-quote symbol-at-point) "$"))
               (matching-symbols (delq nil
                                       (mapcar
                                        (lambda (symbol)
                                          (if (string-match regexp symbol)
                                              symbol))
                                        symbol-names))))
          (when matching-symbols
            (sort matching-symbols (lambda (a b) (> (length a) (length b))))
            (mapc (lambda (symbol)
                    (setq symbol-names (cons symbol
                                             (delete symbol symbol-names))))
                  matching-symbols)))))
    (let* ((selected-symbol (ido-completing-read "Symbol? " (reverse symbol-names)))
           (position (cdr (assoc selected-symbol name-and-pos))))
      (goto-char (if (overlayp position) (overlay-start position) position)))))
