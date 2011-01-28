;Disable toolbar
(tool-bar-mode -1)

(add-to-list 'load-path "~/.emacs.d/site-lisp")
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(add-to-list 'load-path "~/.emacs.d/powershell")
(add-to-list 'load-path "~/.emacs.d/dvc/lisp")
(add-to-list 'load-path  "~/.emacs.d/wl-2.14.0")
(add-to-list 'load-path "~/.emacs.d/git-emacs")
;; (add-to-list 'load-path "~/.emacs.d/mo-git-blame")

(if (equal system-type 'windows-nt)
	(progn	
	  (add-to-list 'load-path "~/.emacs.d/w32-fullscreen")
	  (require 'darkroom-mode)
	  (global-set-key (kbd "C-c m") 'w32-fullscreen)))

;; Dont collide with git emacs
;; (require 'dvc-autoloads)
(require 'git-emacs)
(require 'blank-mode)
;(load "ant")
(load "google")
(load "misc")
(load "nsi-mode")
(load "psvn")
(load "replay.el")
(load "context.el")
(load "color-theme.el")
;(load "zenburn.el")
(load "powershell.el")
(load "revbufs.el")
(load "show-functions.el")
(load "grep-buffers.el")


(cua-mode)
;this is taking too long.. Use only when necessary. Btw, How do I autoload this?
;(load "~/.emacs.d/nxhtml/autostart.el")
(autoload 'bm-toggle   "bm" "Toggle bookmark in current buffer." t)
(autoload 'bm-next     "bm" "Goto bookmark."                     t)
(autoload 'bm-previous "bm" "Goto previous bookmark."            t)
(autoload 'bm-show-all "bm" "Show all bookmarks"                 t)


(autoload 'wl "wl" "Wanderlust" t)
(autoload 'gtags-mode "gtags" "" t)
(autoload 'blank-mode           "blank-mode" "Toggle blank visualization."        t)

;; This shit does not work
;; (autoload 'mo-git-blame-file "mo-git-blame" nil t)
;; (autoload 'mo-git-blame-current "mo-git-blame" nil t)

(modify-frame-parameters (selected-frame) 
  `((alpha . 99)))

(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
	 (color-theme-blackboard)))
     ;(color-theme-zenburn)
	 


(read-context) ;restore context
(which-func-mode t)

(add-hook 'dired-load-hook
		  (lambda ()
			(load "dired-x")
			;; Set dired-x global variables here.  For example:
			;; (setq dired-guess-shell-gnutar "gtar")
			;; (setq dired-x-hands-off-my-keys nil)
			))

;See this link for what these syntax variables mean
;http://www.phys.ufl.edu/docs/emacs/emacs_252.html#SEC258
;set c-style (proper indentation)
(c-add-style "my-c-style" 
			 '((c-basic-offset  . 4)
			   (c-comment-only-line-offset . 0)
			   (c-hanging-braces-alist . ((brace-list-open)
										  (brace-entry-open)
										  (substatement-open after)
										  (block-close . c-snug-do-while)
										  (arglist-cont-nonempty)))
			   (c-cleanup-list . (brace-else-brace))
			   (c-offsets-alist . ((statement-block-intro . +)
								   (knr-argdecl-intro     . 0)
								   (comment-intro         . 0)
								   (substatement-open     . 0)
								   (substatement-label    . 0)
								   (label                 . 0)
								   (statement-cont        . +)
								   (statement-case-open   . +)))))

(c-add-style  "my-java-style"
			  '((c-basic-offset . 4)
				(c-comment-only-line-offset . (0 . 0))
				;; the following preserves Javadoc starter lines
				(c-hanging-braces-alist . ((brace-list-open)
										   (brace-entry-open after)
										   (substatement-open after)
										   (block-close . c-snug-do-while)
										   (arglist-cont-nonempty)))
				(c-offsets-alist . ((inline-open . 0)
									(topmost-intro-cont    . +)
									(statement-block-intro . +)
									(knr-argdecl-intro     . 5)
									(comment-intro         . 0)
									(substatement-open     . 0)
									(substatement-label    . +)
									(label                 . +)
									(statement-case-open   . 0)
									(statement-cont        . 0)
									(arglist-intro  . c-lineup-arglist-intro-after-paren)
									(arglist-close  . c-lineup-arglist)
									(access-label   . 0)
									(inher-cont     . c-lineup-java-inher)
									(func-decl-cont . c-lineup-java-throws)))))

(setq c-default-style
	  '((java-mode . "my-java-style") (other . "my-c-style")))

;Key Bindings
(global-set-key   (kbd "C-/")     'comment-line-or-region)
(global-set-key   (kbd "C-\\")    'uncomment-line-or-region)
(global-set-key   (kbd "C-c q")   'replace-string)
(global-set-key   (kbd "C-c p")   'goto-line)
(global-set-key   (kbd "C-c C-b") 'search-forward-regexp)
(global-set-key   (kbd "C-c d")   'svn-file-show-svn-diff)
(global-set-key   (kbd "C-c s")   'google-search-selection)
(global-set-key   (kbd "C-c g")   'google-it)
(global-set-key   (kbd "C-c y")   'youtube-search)
(global-set-key   (kbd "C-c u")   'my-browse-url)
(global-set-key   (kbd "C-c f")   'grep)
(global-set-key   (kbd "C-c r f") 'recursive-grep)
(global-set-key   (kbd "C-c b")   'grep-buffers)
(global-set-key   (kbd "C-c c")   'compile)
(global-set-key   (kbd "C-c 1")   'bm-toggle)
(global-set-key   (kbd "C-c 2")   'bm-next)
(global-set-key   (kbd "C-c 3")   'bm-previous)
(global-set-key   (kbd "C-c 0")   'bm-show-all)
(global-set-key   (kbd "C-c h")   'switch-to-h-file);should only be for c/c++
(global-set-key   (kbd "C-c a")   'open-fileline)
(global-set-key   (kbd "C-c z")   'close-all-buffers)
(global-set-key   (kbd "M-.")     'gtags-find-tag)

;(global-set-key (kbd "C-c j")  'jad)

;; (global-ede-mode 1)
;; (semantic-mode 1)
;;(semantic-load-enable-code-helpers)
;;(global-srecode-minor-mode 1)



;temp
(global-set-key (kbd "C-c t") 'nsis-create-macro)

(setq-default tab-width 4)

(autoload 'nsi-mode "nsi-mode" "nsi editing mode." t)
(add-to-list 'auto-mode-alist '("\\.nsi$" . nsi-mode))
(add-to-list 'auto-mode-alist '("\\.nsh$" . nsi-mode))
(setq whitespace-style '(trailing tabs newline tab-mark newline-mark))

(setq-default global-linum-mode t)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(display-time-mode t)
 '(fringe-mode (quote (0)) nil (fringe))
 '(indicate-buffer-boundaries (quote ((t . right) (top . left))))
 '(show-paren-mode t)
 '(size-indication-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
