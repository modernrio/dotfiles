;;;;;;;;;;;;;;;;;;;;;;;;
;; Package management ;;
;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup basic package control
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(setq package-enable-at-startup nil)
(package-initialize)

;; Use 'use-package' for package management
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;
;; Essential settings ;;
;;;;;;;;;;;;;;;;;;;;;;;;
;; Disable the welcome screen/messages
(setq inhibit-splash-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message "wolfe")

;; Disable all GUI bars
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; Highlight matching parens
(show-paren-mode t)
;; Scratch buffer blank by default
(setq initial-scratch-message "")

;; Use short 'y' instead of 'yes<RET>' when prompted
(fset 'yes-or-no-p 'y-or-n-p)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Set font settings
(when (member "Inconsolata" (font-family-list))
  (add-to-list 'default-frame-alist '(font . "Inconsolata-12" ))
  (set-face-attribute 'default t :font "Inconsolata-12"))

;; Theme
(use-package doom-themes
  :config
  (load-theme 'doom-one t))

;; Disable backups
(setq make-backup-files nil)

;; Set shortcuts in registers for often used files
(set-register ?e (cons 'file "~/.emacs.d/init.el"))
(set-register ?p (cons 'file "~/org/personal.org"))
(set-register ?t (cons 'file "~/tud/tud.org"))

;;;;;;;;;;;;;;;;;;
;; Org settings ;;
;;;;;;;;;;;;;;;;;;
;; Add org files to agenda
(load-library "find-lisp")
(setq org-agenda-files
      (find-lisp-find-files "~/tud/" "\.org$"))
(add-to-list 'org-agenda-files "~/org/" 'append)

;; Add TODO keywords
(setq org-todo-keywords
      '((sequence "TODO(t@/!)" "NEXT(n/!)" "STARTED(s)" "WAITING(w@/!)" "SOMEDAY(s/!)" "PROJ(p)" "|" "DONE(d)" "CANCELED(c)")))

;: Make customize *never* save options
(setq custom-file "/dev/null")

;; Refile to all agenda files
(setq org-refile-targets '(
   (nil :maxlevel . 2)             ; refile to headings in the current buffer
   (org-agenda-files :maxlevel . 2) ; refile to any of these files
   ))

;; Use file path when refiling
(setq org-refile-use-out-line-path (quote file))

;; Prompt for confirmation if new parent node is refiled
(setq org-refile-allow-creating-parent-nodes (quote confirm))

;; Define capture key
(global-set-key (kbd "\C-cr") 'org-capture)

;; Org Capture (TODO)
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/personal.org" "Aufgaben")
         "* TODO %?\n %i\n")))

;; Include TODO entries and avoid duplicates when exporting to iCal
(setq org-icalendar-include-todo t
      org-icalendar-store-UID t)

;; Load org-babel languages
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-babel-load-languages (quote ((C . t) (java . t))))
 '(org-confirm-babel-evaluate nil))

;; Enable entities and syntax highlight source code blocks.
;; Also do fontify stuff do make the theme look better
(setq org-pretty-entities t
      org-src-fontify-natively t)
      ;org-fontify-whole-heading-line t
      ;org-fontify-done-headline t
      ;org-fontify-quote-and-verse-blocks t)

;; Better looking org headers
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))


;;;;;;;;;;;;;;;;;;;;;;
;; Package settings ;;
;;;;;;;;;;;;;;;;;;;;;;
;; Use 'ido' for minibuffer completion
(use-package ido
  :init
  (defun my-ido-keys()
    "Add keybindings for ido"
    (define-key ido-completion-map [tab] 'ido-next-match))
  (add-hook 'ido-setup-hook #'my-ido-keys)
  :config
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere 1)
  (ido-mode 1))

;; 'smex' uses ido for M-x
(use-package smex
  :config
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command))

;; Use git inside emacs
(use-package magit
  :config
  (global-set-key "\C-x\g" 'magit-status))

;; Replace modeline with a more appealing 'spaceline'
(use-package spaceline-config
  :ensure spaceline
  :pin melpa-stable
  :config
  (spaceline-emacs-theme))

;; General package
(use-package general :ensure t
  :config
  (general-define-key
   :states '(normal visual emacs)
   :prefix ","
   :non-normal-prefix "C-,"

    ;; simple command
    "'"   '(iterm-focus :which-key "iterm")
    "?"   '(iterm-goto-filedir-or-home :which-key "iterm - goto dir")
    "/"   'counsel-ag
    "TAB" '(switch-to-other-buffer :which-key "prev buffer")
    "SPC" '(avy-goto-word-or-subword-1  :which-key "go to char")

    ;; Applications
    "ad" 'dired))


;; Use evil-mode
(use-package evil
  :ensure t
  :init
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)

  :config
  (evil-mode)

  ;; <ESC> should quit *everything*
  (defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
  In Delete Selection mode, if the mark is active, just deactivate it;
  then it takes a second \\[keyboard-quit] to abort the minibuffer."
    (interactive)
    (if (and delete-selection-mode transient-mark-mode mark-active)
        (setq deactivate-mark  t)
      (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
      (abort-recursive-edit)))
  (define-key evil-normal-state-map [escape] 'keyboard-quit)
  (define-key evil-visual-state-map [escape] 'keyboard-quit)
  (define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit))

(use-package evil-search-highlight-persist
  :ensure t
  :config
  (global-evil-search-highlight-persist t))

;; evil-mode keybindings for org-mode
(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme))))

(use-package org
  :ensure t
  :config
  (define-key global-map "\C-cl" 'org-store-link)
  (define-key global-map "\C-ca" 'org-agenda)
  (setq org-log-done t))

(use-package nlinum-relative
  :config
  ;; something else you want
  (nlinum-relative-setup-evil)
  (add-hook 'prog-mode-hook 'nlinum-relative-mode)
  (setq nlinum-relative-redisplay-delay 0)      ;; delay
  (setq nlinum-relative-current-symbol "->")      ;; or "" for display current line number
  (setq nlinum-relative-offset 0))                 ;; 1 if you want 0, 2, 3...



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
