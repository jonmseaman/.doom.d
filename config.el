;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jon Seaman"
      user-mail-address "jonmseaman@google.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Workspace/Notes/Org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.




;; Enable the GUI
; Menu bar makes org-mode and other feature much more discoverable.
(menu-bar-mode 1)
(scroll-bar-mode 1)

(after! org
   (setq org-directory "~/Workspace/Notes/Org"
      org-agenda-files '("~/Workspace/Notes/Org/Inbox.org"
                         "~/Workspace/Notes/Org/Jonathan.org"
                         "~/Workspace/Notes/Org/Actions.org"
                         "~/Workspace/Notes/Org/Tickler.org"
                         "~/Workspace/Notes/Org/Waiting.org")
      org-default-notes-file (expand-file-name "Inbox.org" org-directory)
      org-log-done 'time)

    (setq org-capture-templates '(("t" "Todo [inbox]" entry
                          (file+headline "~/Workspace/Notes/Org/Inbox.org" "Tasks")
                          "* TODO %i%?")
                         ("T" "Tickler" entry
                          (file+headline "~/Workspace/Notes/Org/Tickler.org" "Tickler")
                          "* %i%? \n %U")))

    (setq org-refile-targets '(("~/Workspace/Notes/Org/Jonathan.org" :maxlevel . 3)
                       ("~/Workspace/Notes/Org/LaterMaybe.org" :level . 1)
                       ("~/Workspace/Notes/Org/Waiting.org" :level . 2)
                       ("~/Workspace/Notes/Org/Actions.org" :level . 2)
                       ("~/Workspace/Notes/Org/Archive.org" :maxlevel . 3)
                       ("~/Workspace/Notes/Org/Tickler.org" :maxlevel . 2)))

    (setq org-src-preserve-indentation nil
      org-src-tab-acts-natively t
      org-edit-src-content-indentation 0)

    (with-no-warnings
      (custom-declare-face '+org-todo-active  '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
      (custom-declare-face '+org-todo-project '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
      (custom-declare-face '+org-todo-onhold  '((t (:inherit (bold warning org-todo)))) "")
    )

    ; Pulled from default doom config.
    ; I simplified it and changed the KILL to look the same as DONE.
    ; https://github.com/doomemacs/doomemacs/blob/7e50f239c46ea17429f159fb543c0d793543c06e/modules/lang/org/config.el
	(setq org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "PROJ(p)"  ; A project, which usually contains other tasks
           "LOOP(r)"  ; A recurring task
           "STRT(s)"  ; A task that is in progress
           "WAIT(w)"  ; Something external is holding up this task
           "HOLD(h)"  ; This task is paused/on hold because of me
           "|"
           "DONE(d)"  ; Task successfully completed
           "KILL(k)" ; Task was cancelled, aborted or is no longer applicable
         ))
        org-todo-keyword-faces
        '(("STRT" . +org-todo-active)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("PROJ" . +org-todo-project)
		  ))
)


(use-package! org-mouse
  :custom
  (org-mouse-features
   '(context-menu move-tree yank-link activate-stars activate-bullets activate-checkboxes)))

(setq scroll-step 1)
(setq scroll-margin 7)

(after! org
  (setq org-image-actual-width 400))


;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; 20220223 - changing from doom-dark+ to doom-vibrant for higher contrast.
;; 20220809 - changing from doom-vibrant to doom-oceanic-next for even higher contrast.
(setq doom-theme 'doom-oceanic-next)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; General - increase the responsiveness of auto-completion
;;(setq company-tooltip-idle-delay 0.2)
;;(setq company-idle-delay 0.2)
;;(setq company-minimum-prefix-length 2)

;; General - use English dictionary for spell checking
(setq ispell-dictionary "english")

;; General - Set GC threshold to 32MB for the benefits of all plugins and "flx" the fuzzy matcher in particular
(setq gc-cons-threshold 33554432)

;; General - do not automatically clean up recent file list on exit, this can be quite slow.
(setq recentf-auto-cleanup "never")

;; General - auto-enter "hydra" mode when hitting a breakpoint
(add-hook 'dap-stopped-hook (lambda (arg) (call-interactively #'dap-hydra)))

;; General - ignore case when presenting completion candidates
(setq completion-ignore-case t)

;; General - enable flycheck by default
(global-flycheck-mode)

;; General - auto-update buffer display when the underlying files change
(global-auto-revert-mode t)

;; General - display a ruler at column 80
(setq fill-column 80)
(ignore-errors (global-display-fill-column-indicator-mode t))

;; 20220921 - Temporary workaround for the error message "error Problem in magic-mode-alist with element ess-SAS-listing-mode-p"
(setq magic-mode-alist nil)

;; General - set a "main" project and force projectile not to switch away from
;; it for the respective workspace. Without this mechanism, projectile insists
;; on resetting project root after navigating into a subdirectory.
;;
;; Though this workaround can be used with any proprietary and open source
;; project, it is especially helpful for editing google3 code, which suffers
;; greatly from projectile resetting its project root, seemlingly at random.
;;
;; With this workaround in place, a typical emacs session goes like:
;; 1. Start doom-emacs.
;; 2. Add a google3 sub-directory as a new project (SPC-p-a).
;; 3. Create a new worksapce (SPC-tab-n).
;; 4. Select the google3 sub-directory project (SPC-p-p).
;; 5. Immediately select a file underneath the project directory
;;    (e.g. OWNERS, README, BUILD).
;;    * Do not select a file in a sub-directory of the project
;;      (e.g. project/subdir/main.go) as the workaround uses the directory of
;;      the selected file to determine the true project root.
;; 5. Activate the workaround with SPC-G-p. The workaround function memorises the
;;    project root for the workspace and forcibly sets "projectile-project-root"
;;    to it.
(setq hzgl-forced-project-root-path (make-hash-table :test #'equal))
(defun hzgl-force-use-project-root (&rest args)
  ;; Return the force-set project root that belongs to the active workspace.
  (gethash (+workspace-current-name) hzgl-forced-project-root-path))
(defun hzgl-force-set-project-root ()
  "Force projectile to use the current buffer's directory as the project-root of
  this workspace, and never to automatically change it when navigating into a
  sub-directory."
  (interactive)
  ;; Remember the current buffer's directory.
  (puthash (+workspace-current-name) default-directory hzgl-forced-project-root-path)
  ;; Register this function to be called whenever projectile is looking for the project root.
  (advice-add #'projectile-project-root :before-until #'hzgl-force-use-project-root)
  (message "Projectile project root has been force-set to \"%s\" in workspace \"%s\""
           default-directory (+workspace-current-name)))


;; General - improve projectile boundary detection
(after! projectile
  ;; Do not let projects I bump into pollute the project list.
  (setq projectile-track-known-projects-automatically nil)
  ;; Do not automatically clean up projectile project list on exit, this can be quite slow.
  ;; Just redefine the function to a noop.
  (defun projectile-cleanup-known-projects () (interactive)))

;; RSS - set feed URLs
(setq elfeed-feeds '("http://www.abc.net.au/news/feed/45910/rss.xml" "http://feeds.bbci.co.uk/news/rss.xml" "https://www.theguardian.com/uk/rss" "https://www.cnbc.com/id/100003114/device/rss/rss.html"))

;; LSP - adjust flycheck checkers for various programming languages that use an LSP client
(add-hook! 'lsp-after-initialize-hook
  (run-hooks (intern (format "%s-lsp-hook" major-mode))))

(defun hzgl-c-lsp-setup ()
  (ignore-errors (flycheck-add-next-checker 'lsp 'c/c++-cppcheck))
  (ignore-errors (flycheck-add-next-checker 'lsp 'c/c++-clang))
  (ignore-errors (flycheck-add-next-checker 'lsp 'c/c++-gcc)))
(add-hook 'c-mode-lsp-hook #'hzgl-c-lsp-setup)

(defun hzgl-c++-lsp-setup ()
  (ignore-errors (flycheck-add-next-checker 'lsp 'c/c++-cppcheck))
  (ignore-errors (flycheck-add-next-checker 'lsp 'c/c++-clang))
  (ignore-errors (flycheck-add-next-checker 'lsp 'c/c++-gcc))
  (ignore-errors (flycheck-add-next-checker 'lsp 'google-piper-lint))
  (ignore-errors (flycheck-add-next-checker 'lsp 'google-tricorder)))
(add-hook 'c++-mode-lsp-hook #'hzgl-c++-lsp-setup)

(defun hzgl-go-lsp-setup ()
  (ignore-errors (flycheck-add-next-checker 'lsp 'go-gofmt))
  (ignore-errors (flycheck-add-next-checker 'lsp 'go-vet))
  (ignore-errors (flycheck-add-next-checker 'lsp 'google-piper-lint))
  (ignore-errors (flycheck-add-next-checker 'lsp 'google-tricorder)))
(add-hook 'go-mode-lsp-hook #'hzgl-go-lsp-setup)

(defun hzgl-python-lsp-setup ()
  (ignore-errors (flycheck-add-next-checker 'lsp 'python-flake8))
  (ignore-errors (flycheck-add-next-checker 'lsp 'python-pylint))
  (ignore-errors (flycheck-add-next-checker 'lsp 'google-piper-lint))
  (ignore-errors (flycheck-add-next-checker 'lsp 'google-tricorder)))
(add-hook 'python-mode-lsp-hook #'hzgl-python-lsp-setup)

(defun hzgl-sh-lsp-setup ()
  (ignore-errors (flycheck-add-next-checker 'lsp 'sh-bash))
  (ignore-errors (flycheck-add-next-checker 'lsp 'sh-shellcheck)))
(add-hook 'sh-mode-lsp-hook #'hzgl-sh-lsp-setup)

(defun hzgl-js2-lsp-setup ()
  (ignore-errors (flycheck-add-next-checker 'lsp 'javascript-eslint))
  (ignore-errors (flycheck-add-next-checker 'lsp 'javascript-jshint))
  (ignore-errors (flycheck-add-next-checker 'lsp 'javascript-standard)))
(add-hook 'js2-mode-lsp-hook #'hzgl-js2-lsp-setup)

;; Go - use goimports to maintain import() on save
(defun hzgl-go-mode-hook ()
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))
(add-hook 'go-mode-hook 'hzgl-go-mode-hook)

;; Go - prevent guru tool from wondering around too far though I do not usally install it
(when (not (string-match-p "google" (system-name)))
  (setq go-guru-scope "github.com/HouzuoGuo/..."))

;; Initialisation for google owned workstation.
;;(when (or
        ;;(not (not (string-match-p "google" (system-name))))
        ;;(not (not (string-match-p "roam.internal" (system-name)))))
  ;;;;(use-package! google)
  ;;;;(use-package! google-cc-add-using)
  ;;;;(use-package! google-cc-extras)
  ;;;;(use-package! google-codemaker :config (google-codemaker-auto-mode 1))
  ;;;;(use-package! google-diformat)
  ;;;;(use-package! google-ediff)
  ;;;;(use-package! google-engdoc :init (google-engdoc-init))
  ;;;;(use-package! google-findings)
  ;;;; Disable Flymake because I use FlyCheck
  ;;;;(use-package! google-flymake)
  ;;;;(use-package! google-imports)
  ;;;;(use-package! google-imports-iwyu)
  ;;;;(use-package! google-java-format)
  ;;;;(use-package! google-pyformat)
  ;;;;(use-package! google-trailing-whitespace)
  ;;;;(use-package! google-tricorder)
  ;;;; 20210715 - Disable yasnippets because it confuses company autocomplete
  ;;;; (use-package! google-yasnippets :config (google-yasnippets-load))
  ;;;;(use-package! google3)
  ;;;;(use-package! google3-build :config (setq google3-build-target-method 'blaze))
  ;;;; CAUTION: build-capf interferes with "value of c-a-p-f" (as observed by company-diag), ends up changing it from "lsp-complete-at-point" to "google3".
  ;;;;(use-package! google3-build-capf :config (google3-build-capf-enable-completions))
  ;;;;(use-package! google3-build-cleaner)
  ;;;;(use-package! google3-build-mode)
  ;;;;(use-package! google3-display-coverage)
  ;;;;(use-package! google3-mode)
  ;;;;(use-package! google3-quickrun)
  ;;;;(use-package! clang-include-fixer)
  ;;;;(use-package! cs)
  ;;;;(use-package! gogolink)
  ;;;;(use-package! java-imports)
  ;;;;(use-package! p4-google)
  ;;;; 20211103 - ivy-cs used to break doom-emacs' beautiful ivy display, though this appears to have been fixed.
  ;;;;(use-package! ivy-cs)

  ;;(use-package! protobuffer :config (setq protobuffer-format-before-save t))
  ;;(set-formatter! 'google-diformat-clang-formatter #'google-diformat-clang-format-changed :modes '(c-mode c++-mode))
  ;;(set-formatter! 'google-diformat-java-formatter #'google-diformat-google-java-format-changed :modes '(java-mode))
  ;;(set-formatter! 'google-diformat-python-formatter #'google-diformat-pyformat-changed :modes '((python-mode (not (eq major-mode 'google3-build-mode)))))
  ;;(set-formatter! 'google-markdown-formatter #'google-mdformat :modes '(markdown-mode))
  ;;(set-formatter! 'google-tide-clang-formatter #'google-clang-format-file :modes '(tide-mode typescript typescript-mode))
  ;;(setq +format-on-save-enabled-modes '(c-mode c++-mode java-mode markdown-mode python-mode tide-mode typescript-mode))

  ;;(add-hook! 'ediff-keymap-setup-hook :append #'add-d-to-ediff-mode-map)
  ;;;; 20210715 - java-imports-scan-file throws an error: File mode specification error: (doom-hook-error java-mode-hook java-imports-scan-file (error Bad bounding indices: 1, nil))
  ;;;; 20220225 - java-imports-scan-file no longer throws the error, it now works.
  ;;(add-hook! 'java-mode-hook 'java-imports-scan-file)
  ;;;; 20220225 - this is the recommended way to auto-format java code on save, according to google_java_format.
  ;;(add-hook! 'java-mode-hook #'(lambda () (add-hook 'before-save-hook #'google-diformat-google-java-format-changed nil :local)))
  ;;(add-hook! c++-mode (add-hook! 'before-save-hook :local :append #'google-clang-format-file nil :local))
  ;;;; 20210715 - I personally do not prefer subword mode
  ;;;; (add-hook! google3-mode 'subword-mode)
  ;;(add-hook! markdown-mode (add-hook! 'before-save-hook :local :append #'google-mdformat-before-save))
  ;;(add-hook! python-mode (add-hook! 'before-save-hook :local :append (lambda () (unless (eq major-mode 'google3-build-mode) (add-hook 'before-save-hook #'google-pyformat nil t)))))
  ;;(add-hook! tide-mode (add-hook! 'before-save-hook :local :append #'google-clang-format-file))
  ;;(add-hook! typescript-mode (add-hook! 'before-save-hook :local :append #'google-diformat-clang-format-changed))

  ;;(if (eq system-type 'gnu/linux)
    ;;;; The LSP runs locally on a Linux host.
    ;;(progn
      ;;(with-eval-after-load 'lsp-mode
        ;;(add-to-list 'lsp-language-id-configuration '(borg-mode . "borg"))
        ;;;; 20220119 - make LSP recognise borg-mode and BUILD files, otherwise LSP will not initialise and complain that it cannot find an "active workspace".
        ;;(add-to-list 'lsp-language-id-configuration '(google3-build-mode . "BUILD"))
        ;;(add-to-list 'lsp-language-id-configuration '(ncl-mode . ".blueprint"))
        ;;(add-to-list 'lsp-language-id-configuration '(piccolo-mode . ".pi"))
        ;;(add-to-list 'lsp-language-id-configuration '(protobuf-mode . ".proto"))
        ;;;; 20220804 - edit METADATA in protobuffer mode (which differs from protobuf mode).
        ;;(add-to-list 'lsp-language-id-configuration '(protobuffer-mode . "METADATA"))
        ;;(add-to-list 'lsp-language-id-configuration '(skylark-mode . ".bzl"))
        ;;;; When opening a go project from /google, replace the gopls LSP (at the default priority) with cider also at the default priority.
        ;;(when (or (string-prefix-p "/google" (buffer-file-name)) (string-prefix-p "/Volumes/google" (buffer-file-name)))
          ;;(lsp-register-client
            ;;(make-lsp-client
             ;;:priority 0
             ;;:new-connection (lsp-stdio-connection '("/google/bin/releases/cider/ciderlsp/ciderlsp" "--noforward_sync_responses" "--tooltag=remote-emacs-eglot" "--request_options=enable_placeholders"))
             ;;:major-modes '(borg-mode c-mode cc-mode c++-mode go-mode google3-build-mode java-mode markdown-mode ncl-mode piccolo-mode protobuf-mode protobuffer-mode python-mode skylark-mode tide-mode typescript-mode)
             ;;:server-id 'ciderlsp-local)))))
    ;;;; On other OSes, use LSP over an SSH connection.
    ;;(progn
      ;;(with-eval-after-load 'lsp-mode
        ;;(add-to-list 'lsp-language-id-configuration '(borg-mode . "borg"))
        ;;;; 20220119 - make LSP recognise borg-mode and BUILD files, otherwise LSP will not initialise and complain that it cannot find an "active workspace".
        ;;(add-to-list 'lsp-language-id-configuration '(google3-build-mode . "BUILD"))
        ;;(add-to-list 'lsp-language-id-configuration '(ncl-mode . ".blueprint"))
        ;;(add-to-list 'lsp-language-id-configuration '(piccolo-mode . ".pi"))
        ;;(add-to-list 'lsp-language-id-configuration '(protobuf-mode . ".proto"))
        ;;;; 20220804 - edit METADATA in protobuffer mode (which differs from protobuf mode).
        ;;(add-to-list 'lsp-language-id-configuration '(protobuffer-mode . "METADATA"))
        ;;(add-to-list 'lsp-language-id-configuration '(skylark-mode . ".bzl"))
        ;;;; When opening a go project from /google, replace the gopls LSP (at the default priority) with cider also at the default priority.
        ;;(when (or (string-prefix-p "/google" (buffer-file-name)) (string-prefix-p "/Volumes/google" (buffer-file-name)))
          ;;(lsp-register-client
            ;;(make-lsp-client
             ;;:priority 0
             ;;:new-connection (lsp-stdio-connection '("ssh" "ws" "/google/bin/releases/cider/ciderlsp/ciderlsp --noforward_sync_responses --tooltag=remote-emacs-eglot" "--request_options=enable_placeholders"))
             ;;:major-modes '(borg-mode c-mode cc-mode c++-mode go-mode google3-build-mode java-mode markdown-mode ncl-mode piccolo-mode protobuf-mode protobuffer-mode python-mode skylark-mode tide-mode typescript-mode)
             ;;:server-id 'ciderlsp-over-ssh)))))))

(map!
  (:leader
    (:prefix ("G" . "Howard's good stuff")
       :desc "Force-set main project for this workspace" :n "p" #'hzgl-force-set-project-root
       :desc "Code search" :n "s" #'ivy-cs
       :desc "Code search file" :n "f" #'ivy-cs-files
       :desc "Fig Fix" :n "F" #'fig-fix)))
