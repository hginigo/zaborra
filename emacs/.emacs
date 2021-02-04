;;; package --- Summary
;;; Commentary:
;; --------------------------------------
;; -- A fresh installation of Emacs :) --
;; --------------------------------------
;;; Code:
(load "~/.emacs.d/init.el")

;; ---------------------------
;; -- Configure use-package --
;; ---------------------------
;; Ensure use-package will install a package if it is not.
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Always compile packages and use the newest version.
(use-package auto-compile
	     :config (auto-compile-on-load-mode))

(setq load-prefer-newer t)

;; Disable TLS 1.3
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; ----------------------------------
;; -- Basic settings and UI tweaks --
;; ----------------------------------
;; Disable startup screen
(setq inhibit-startup-screen t)

;; Disable menu bar and tools bar
(menu-bar-mode 0)
(tool-bar-mode 0)

;; Disable scroll bar
(scroll-bar-mode -1)

;; Disable bell sound and visual bell
(setq ring-bell-function 'ignore)

;; Set title to something more useful
(setq frame-title-format '((:eval (projectile-project-name))))

;; Scroll like in Vim :)
(setq scroll-conservatively 100)

;; Use fancy lambdas
(global-prettify-symbols-mode t)

;; Display line numbers
(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

;; Load up a theme
(use-package gruber-darker-theme)

(defun transparency (value)
  "Set the transparency of the frame window with VALUE.  0: transparent / 100: opaque."
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))

(defun hg/apply-theme ()
  "Apply my chosen theme and make frames opaque."
  (interactive)
  (load-theme 'gruber-darker t)
  (transparency 100))

(if (daemonp)
    (add-hook 'after-make-functions
	      (lambda (frame)
		(with-selected-frame frame (hg/apply-theme))))
  (hg/apply-theme))

;; Font configuration
(custom-theme-set-faces
 'user
 '(variable-pitch ((t (:family "Liberation Serif" :height 70 :weight thin))))
 '(fixed-pitch ((t (:family "Inconsolata" :height 70)))))

(setq hg/default-font "Inconsolata")
;(setq hg/default-font "Monaco")
;(setq hg/default-font "Ubuntu Mono")
(setq hg/default-font-size 13)
(setq hg/current-font-size hg/default-font-size)

(setq hg/font-change-increment 1.1)

(defun hg/font-code ()
  "Return a string representing the current font."
  (concat hg/default-font "-" (number-to-string hg/current-font-size)))

(defun hg/set-font-size ()
  "Set the font to 'hg/default-font at 'hg/current-font-size'.
Set it for the current frame and also make it the default."
  (let ((font-code (hg/font-code)))
    (if (assoc 'font default-frame-alist)
	(setcdr (assoc 'font default-frame-alist) font-code)
      (add-to-list 'default-frame-alist (cons 'font font-code)))
    (set-frame-font font-code)))

(defun hg/reset-font-size ()
  "Change font size back to 'hg/default-font-size'."
  (interactive)
  (setq hg/current-font-size hg/default-font-size)
  (hg/set-font-size))

(defun hg/increase-font-size ()
  "Increase current font size by a factor of 'hg/font-change-increment'."
  (interactive)
  (setq hg/current-font-size
	(floor (* hg/current-font-size hg/font-change-increment)))
  (hg/set-font-size))
 
(defun hg/decrease-font-size ()
  "Decrease current font size by a factor of 'hg/font-change-increment'."
  (interactive)
  (setq hg/current-font-size
	(max 1
	     (ceiling (/ hg/current-font-size hg/font-change-increment))))
  (hg/set-font-size))

(define-key global-map (kbd "C-)") 'hg/reset-font-size)
(define-key global-map (kbd "C-+") 'hg/increase-font-size)
(define-key global-map (kbd "C--") 'hg/decrease-font-size)

(hg/reset-font-size)

;; Highlight current line
(global-hl-line-mode)

;; ------------------
;; -- My functions --
;; ------------------

(defun hg/open-doc (directory)
  "Fuction to quickly open docs of a DIRECTORY."
  (interactive)
  (list-directory directory))

;; ---------------
;; -- Evil mode --
;; ---------------
(use-package evil
	     :init
	     (setq evil-want-abbrev-expand-on-insert-exit nil
		   evil-want-keybinding nil)

	     :config
	     (evil-mode 1))

;; Install evil-collection
(use-package evil-collection
	     :after evil
	     :config
	     (setq evil-collection-mode-list
		   '(ag dired magit mu4 which-key))
	     (evil-collection-init))

;; Enable surround everywhere
(use-package evil-surround
	     :config
	     (global-evil-surround-mode 1))

;; Use evil with org agendas
(use-package evil-org
	     :after org
	     :config
	     (add-hook 'org-mode-hook 'evil-org-mode)
	     (add-hook 'evil-org-mode-hook
		       (lambda () (evil-org-set-key-theme)))
	     (require 'evil-org-agenda)
	     (evil-org-agenda-set-keys))

;; ----------------------
;; -- Editing settings --
;; ----------------------
;; Shortcut to quickly visit Emacs configuration
(defun hg/visit-emacs-config ()
  "Quickly visit my Emacs config file."
  (interactive)
  (find-file "~/.emacs"))

(global-set-key (kbd "C-c e") 'hg/visit-emacs-config)

;; Kill current buffer
(defun hg/kill-current-buffer ()
  "Kill the current buffer without prompting."
  (interactive)
  (kill-buffer (current-buffer)))

(global-set-key (kbd "C-x k") 'hg/kill-current-buffer)

;; Set up helpful
(use-package helpful)
(global-set-key (kbd "C-h f") #'helpful-callable)
(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)

(evil-define-key 'normal helpful-mode-map (kbd "q") 'quit-window)

;; Save place when closing
(save-place-mode t)

;; Always indent with spaces
(setq-default indent-tabs-mode nil)

;; Configure which-key
(use-package which-key
  :config (which-key-mode))

;; Configure yasnippet
(use-package yasnippet
  :ensure t
  :config
  (use-package yasnippet-snippets
    :ensure t))

(setq yas-snippet-dirs '("~/.emacs.d/snippets/text-mode"))
(yas-reload-all)
(yas-global-mode 1)

(setq yas-indent-line 'auto)

;; Configure ivy and counsel
(use-package counsel
  :bind
  ("M-x" . 'counsel-M-x)
  ("C-s" . 'swiper)

  :config
  (use-package flx)
  (use-package smex)

  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-re-builders-alist
	'((swiper . ivy--regex-plus)
	  (t . ivy--regex-fuzzy))))

;; Better management of backup files
(setq backup-by-copying t
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
      delete-old-versions t
      kept-new-versions 3
      kept-old-versions 1
      version-control t)

;; Delete old backup files not acessed in a week
(message "Deleting old backup files...")
(let ((week (* 60 60 24 7))
      (current (float-time (current-time))))
  (dolist (file (directory-files temporary-file-directory t))
    (when (and (backup-file-name-p file)
               (> (- current (float-time (nth 5 (file-attributes file))))
                  week))
      (message "%s" file)
      (delete-file file))))

;; Open pdf documents with Zathura
(use-package openwith)
(require 'openwith)
(openwith-mode t)
(setq openwith-associations '(("\\.pdf\\'" "zathura" (file))))

;; ------------------------
;; -- Project management --
;; ------------------------
;; Use ag
(use-package ag)

;; Use company
(defun indent-or-complete ()
  "Indent or complete for company."
  (interactive)
  (if (looking-at "\\_>")
      (company-complete-selection)
  (indent-according-to-mode)))

(use-package company
  :ensure t
  :config
  (setq company-backends '(company-capf))
  (define-key company-active-map (kbd "<tab>") nil)
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "TAB") #'indent-or-complete)
  (define-key company-active-map (kbd "C-j") #'company-select-next)
  (define-key company-active-map (kbd "C-k") #'company-select-previous))
(add-hook 'after-init-hook 'global-company-mode)

;; Use flycheck
(use-package let-alist)
(use-package flycheck
  :init (global-flycheck-mode))

;; magit config
(use-package magit
  :bind
  ("C-x g" . magit-status)

  :config
  (use-package evil-magit)
  (use-package with-editor)

  ;(setq magit-push-always-verify nil
  ;	git-commit-summary-max-length 50)
  (add-hook 'with-editor-mode-hook 'evil-insert-state))

;; projectile config
(use-package projectile
  :ensure t
  :bind
  ("C-c v" . projectile-ag)

  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

  (define-key evil-normal-state-map (kbd "C-p") 'projectile-find-file)
  (evil-define-key 'motion ag-mode-amp (kbd "C-p") 'projectile-find-file)
  (evil-define-key 'motion rspec-mode-map (kbd "C-p") 'projectile-find-file)
  (evil-define-key 'motion rspec-compilation-mode-map (kbd "C-p") 'projectile-find-file)

  (setq projectile-completion-system 'ivy
	projectile-switch-project-action 'projectile-dired
	projectile-require-project-root nil))

;; Use undo-tree
(use-package undo-tree)

;; Quckly start weka
(defun hg/init-weka ()
  "Automatically start an instance of Weka."
  (interactive)
  (shell-command "~/docs/uni/dm/weka-3-8-4/weka.sh &"))

;; ------------------------------
;; -- Programming environments --
;; ------------------------------
;; Tabs
(setq-default tab-width 2)

;; Use eglot
(use-package eglot)
(add-hook 'eglot--managed-mode-hook (lambda () (flymake-mode -1)))

;; Haskell mode
(use-package haskell-mode)

(add-hook 'haskell-mode-hook
          (lambda ()
            (haskell-doc-mode)
            (turn-on-haskell-indent)))

;; Use paredit (for lisp)
(use-package paredit)

;; Rainbow-delimiters for parentheses
(use-package rainbow-delimiters)

(setq lispy-mode-hooks
      '(emacs-lisp-mode-hook
        lisp-mode-hook
        scheme-mode-hook))

(dolist (hook lispy-mode-hooks)
  (add-hook hook (lambda ()
                   (setq show-paren-style 'expression)
                   (paredit-mode)
                   (rainbow-delimiters-mode))))

;; Emacs lisp: eldoc and flycheck
(use-package eldoc
  :config
  (add-hook 'emacs-lisp-mode-hook 'eldoc-mode))

(use-package flycheck-package)

(eval-after-load 'flycheck
  '(flycheck-package-setup))

;; Python mode
(use-package python-mode)

(add-to-list 'exec-path "/home/hugo/.config/pyenv/shims/")
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(add-hook 'elpy-mode-hook 'flycheck-mode)

(use-package py-autopep8)
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(use-package company-jedi
  :config
  (require 'company)
  (add-to-list 'company-backends 'company-jedi))

(setq jedi:complete-on-dot t)
(add-hook 'python-mode-hook 'jedi:setup)

;; Java mode

;; Rust mode
(use-package rust-mode
  :config
  (setq rust-format-on-save t)
  (define-key rust-mode-map (kbd "C-c C-c") 'rust-run)
  (add-hook 'rust-mode-hook 'eglot-ensure))

(use-package flycheck-rust)
(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;; Julia mode
(use-package julia-mode)
(require 'julia-mode)

; TODO set another julia repl for evaluation tests,
; change default jupyter location to access directly lab dir.
(defun hg/init-jupyter-notebook ()
  "Automatically init a Jupyter environment."
  (interactive)
  (julia-repl)
  (julia-repl--send-string "using IJulia; notebook()"))
;; notebook(dir = "PATH/TO/DIR", detached = true)

;; Terminal
(use-package multi-term)
(global-set-key (kbd "C-c t") 'multi-term)

(setq multi-term-program-switches "--login")

(evil-set-initial-state 'term-mode 'emacs)

;; LaTeX

;; --------------
;; -- Org mode --
;; --------------
(use-package org
  :ensure org-plus-contrib
  :config
  (require 'org-tempo))

;; Replace ... with an arrow pointing downwards
(setq org-ellipsis "⤵")
(setq org-hide-emphasis-markers t)

;; Use syntax highlighting in source blocks
(setq org-src-fontify-natively t)

;; Use TAB like in the language's major mode
(setq org-src-tab-acts-natively t)

;; Do not open a new window when editing a snippet
(setq org-src-window-setup 'current-window)

;; Set a time stamp when a task is done
(setq org-log-done 'time)

;; Ensure all subtasks are done before completing the main task
(setq org-enforce-todo-dependencies t)
(setq org-enforce-todo-checkbox-dependencies t)

;; Add a binding to quickly visit my uni agenda
(defun hg/visit-uni-agenda ()
  "Quckly visit my uni agenda file."
  (interactive)
  (find-file "~/docs/uni/uni.org"))

(global-set-key (kbd "C-c u") 'hg/visit-uni-agenda)
(global-set-key (kbd "C-c a") 'org-agenda)

;; ------------------
;; -- Email (mu4e) --
;; ------------------
(load "~/.emacs.d/email.el")

(message "Done.")
;; EOF
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-undo-system (quote undo-tree))
 '(package-selected-packages
   (quote
    (company-quickhelp yasnippet-snippets company-jedi openwith org-plus-contrib multi-term rainbow-delimiters eglot smex flx which-key vscode-dark-plus-theme use-package tmux-pane rust-mode julia-repl julia-mode haskell-mode gruber-darker-theme evil-surround evil-paredit evil-org evil-mu4e evil-magit evil-collection dracula-theme counsel auto-compile))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fixed-pitch ((t (:family "Inconsolata" :height 70))))
 '(variable-pitch ((t (:family "Liberation Serif" :height 70 :weight thin)))))
