;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)

(when (or
        (not (not (string-match-p "google" (system-name))))
        (not (not (string-match-p "roam.internal" (system-name)))))
  (when (eq system-type 'gnu/linux)
    (let ((default-directory "/usr/share/emacs/site-lisp/emacs-google-config")) (normal-top-level-add-subdirs-to-load-path)))
  (package! citc :built-in 'prefer)
  (package! clang-include-fixer :built-in 'prefer)
  (package! cs :built-in 'prefer)
  (package! csearch :built-in 'prefer)
  (package! gogolink :built-in 'prefer)
  (package! google :built-in 'prefer)
  (package! google-cc-add-using :built-in 'prefer)
  (package! google-cc-extras :built-in 'prefer)
  (package! google-diformat :built-in 'prefer)
  (package! google-ediff :built-in 'prefer)
  (package! google-emacs-utilities :built-in 'prefer)
  (package! google-engdoc :built-in 'prefer)
  (package! google-findings :built-in 'prefer)
  (package! google-imports :built-in 'prefer)
  (package! google-imports-iwyu :built-in 'prefer)
  (package! google-java-format :built-in 'prefer) ;; 20220225 - adding google-java-format in order to format java code in before-save-hook
  (package! google-lint :built-in 'prefer)
  (package! google-platform :built-in 'prefer)
  (package! google-process :built-in 'prefer)
  (package! google-pyformat :built-in 'prefer)
  (package! google-trailing-whitespace :built-in 'prefer)
  (package! google-tricorder :built-in 'prefer)
  (package! google3 :built-in 'prefer)
  (package! google3-build :built-in 'prefer)
  (package! google3-build-cleaner :built-in 'prefer)
  (package! google3-build-mode :built-in 'prefer)
  (package! google3-display-coverage :built-in 'prefer)
  (package! google3-mode :built-in 'prefer)
  (package! google3-quickrun :built-in 'prefer)
  (package! ivy-cs :built-in 'prefer);; 20211103 - ivy-cs used to break doom-emacs' beautiful ivy display, though this appears to have been fixed.
  (package! java-imports)
  (package! p4-google :built-in 'prefer)
  (package! protobuffer :built-in 'prefer)
  (package! rotate-among-files :built-in 'prefer)
  ;;(package! google-yasnippets :built-in 'prefer) ;; 2021 - Disable yasnippets because it confuses company autocomplete
  ;;(package! google-flymake :built-in 'prefer) ;; 2021 - Disable Flymake because I use FlyCheck
  ;;(package! google3-build-capf :built-in 'prefer) ;; 2021 - CAUTION: build-capf interferes with "value of c-a-p-f" (as observed by company-diag), ends up changing it from "lsp-complete-at-point" to "google3".
  )

;; 20210721 - LSP needs snippets for placeholders, but the built-in snippets are annoying.
(package! doom-snippets :ignore t)