;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jon Seaman"
      user-mail-address "jonmseaman@live.com")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Notes/")


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

;; Adapted from: https://stackoverflow.com/questions/17215868/recursively-adding-org-files-in-a-top-level-directory-for-org-agenda-files-take
(defun org-get-agenda-files-recursively (dir)
  "Get org agenda files from root DIR."
  (directory-files-recursively dir "\.org$"))

(defun org-set-agenda-files-recursively (dir)
  "Set org-agenda files from root DIR."
  (setq org-agenda-files
    (org-get-agenda-files-recursively dir)))

(defun org-add-agenda-files-recursively (dir)
  "Add org-agenda files from root DIR."
  (nconc org-agenda-files
    (org-get-agenda-files-recursively dir)))

(after! org
  (setq org-directory "~/Notes/"
        org-agenda-files '("~/Notes/Actions.org" "~/Notes/Projects.org")
        org-default-notes-file (expand-file-name "Quick Notes.org" org-directory)
        org-log-done 'time
        org-agenda-start-with-follow-mode t
        org-agenda-follow-indirect t
        org-agenda-show-future-repeats nil
        org-todo-repeat-to-state "LOOP"
        org-agenda-todo-ignore-scheduled 'future
        org-agenda-tags-todo-honor-ignore-options t
        )

  ;; Configure org-roam
  ;; (make-directory "~/Notes/3_Reference")
  (setq org-roam-directory (file-truename "~/Notes/"))

  ;; This allows putting your notes directly in a project file and the TODOs
  ;; will appear in the agenda still.
  (org-add-agenda-files-recursively "~/Notes/1_Projects")

  (setq org-capture-templates `(("n" "Note [INBOX in Quick Notes.org]" entry
                                 (file+headline "~/Notes/Quick Notes.org" "INBOX")
                                 "* %i%?" :prepend t)
                                ("t" "Todo [INBOX in Quick Notes.org]" entry
                                 (file+headline "~/Notes/Quick Notes.org" "INBOX")
                                 "* TODO %i%?" :prepend t)
                                ("j" "Journal Entry [Journal.org]" entry
                                 (file "~/Notes/Journal.org")
                                 ,(concat "* %i%?\n"
                                          ":PROPERTIES:\n"
                                          ":CREATED: %<%a %b %e %R %Y>\n"
                                          ":END:\n"
                                          "\n"
                                          "\n"
                                          "** References\n"
                                          "-\n") :prepend t)
                                ))

  (setq org-roam-capture-templates '(("d" "default" plain "%?"
                                      :target (file+head "0_Inbox/%<%Y%m%d%H%M%S>-${slug}.org"
                                                         "#+title: ${title}\n")
                                      :unnarrowed t)))

  (setq org-refile-targets '(("~/Notes/Projects.org" :maxlevel . 3)))

  (setq org-src-preserve-indentation nil
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0)

  (with-no-warnings
    (custom-declare-face '+org-todo-active  '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
    (custom-declare-face '+org-todo-project '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
    (custom-declare-face '+org-todo-onhold  '((t (:inherit (bold warning org-todo)))) "")
    )

  ;; Pulled from default doom config.
  ;; I simplified it and changed the KILL to look the same as DONE.
  ;; https://github.com/doomemacs/doomemacs/blob/7e50f239c46ea17429f159fb543c0d793543c06e/modules/lang/org/config.el
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"             ; A task that needs doing & is ready to do
           "PROJ(p)"             ; A project, which usually contains other tasks
           "EPIC(e)"             ; An epic, for agile-esque task management
           "MILESTONE(m)"        ; An agile milestone
           "STORY(s)"            ; A story, for software-esque task management
           "LOOP(l)"             ; A recurring task
           "PROG(P)"             ; A task that is in progress
           "WAIT(w)"             ; Something external is holding up this task
           "HOLD(h)"             ; This task is paused/on hold because of me
           "|"
           "DONE(d)"    ; Task successfully completed
           "KILL(k)"    ; Task was cancelled, aborted or is no longer applicable
           ))
        org-todo-keyword-faces
        '(("PROG" . +org-todo-active)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("PROJ" . +org-todo-project)
          ("EPIC" . +org-todo-project)
          ("MILESTONE" . +org-todo-project)
          ("STORY" . +org-todo-project))

        )
  (setq org-stuck-projects '("+active+LEVEL=2/+PROJ|EPIC|MILESTONE|STORY-DONE-KILL" ("NEXT" "TODO") nil ""))

  ;; org-agenda-custom-commands, partially adopted from:
  ;; https://protesilaos.com/codelog/2021-12-09-emacs-org-block-agenda/
  (setq org-agenda-custom-commands
        '(
          ("o" "Agenda Current Work Overview"
           (
            ;; Today view.
            (agenda "" ((org-agenda-overriding-header "\nToday's agenda\n")
                        (org-agenda-start-on-weekday nil)
                        (org-agenda-start-day "+0d")
                        (org-agenda-span 1)
                        (org-deadline-warning-days 0)
                        (org-agenda-block-separator nil)
                        (org-scheduled-past-days 0)
                        ;; We don't need the `org-agenda-date-today'
                        ;; highlight because that only has a practical
                        ;; utility in multi-day views.
                        (org-agenda-day-face-function (lambda (date) 'org-agenda-date))
                        (org-agenda-format-date "%A %-e %B %Y")
                        ))
            ;; Upcoming (3 day)
            (agenda "" ((org-agenda-overriding-header "\nNext three days\n")
                        (org-agenda-start-on-weekday nil)
                        (org-agenda-start-day "+1d")
                        (org-agenda-span 3)
                        (org-deadline-warning-days 0)
                        (org-agenda-block-separator nil)
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                        ))
            ;; Upcoming (14 day)
            (agenda "" ((org-agenda-overriding-header "\nUpcoming deadlines (+14d)\n")
                        (org-agenda-time-grid nil)
                        (org-agenda-start-on-weekday nil)
                        ;; We don't want to replicate the previous section's
                        ;; three days, so we start counting from the day after.
                        (org-agenda-start-day "+4d")
                        (org-agenda-span 14)
                        (org-agenda-show-all-dates nil)
                        (org-deadline-warning-days 0)
                        (org-agenda-block-separator nil)
                        (org-agenda-entry-types '(:deadline))
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                        ))
            ;; Current Tasks
            (tags-todo "active" ((org-agenda-overriding-header "\nCurrent Tasks\n")
                        (org-agenda-hide-tags-regexp "active")
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("TODO" "LOOP" "PROG")))
                        (org-agenda-dim-blocked-tasks 'invisible)
                        ))

            ;; Current Projects
            (tags-todo "active"
                       ((org-agenda-hide-tags-regexp "active")
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("PROJ" "EPIC" "MILESTONE" "STORY")))
                        (org-agenda-overriding-header "\nCurrent Projects\n")
                        )
                       )
            (stuck)
            (tags-todo "active"
                       ((org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("WAIT")))
                        (org-agenda-overriding-header "\nWaiting List\n")))
            )
           )
          )
        )


  )

;; org-id-link-to-org-user-id causes org-super-links to use ids rather than the
;; path to the linked note, which makes it easier to maintain.
;; The command org-id-update-id-locations will then be able to update all ids.
(require 'org-id)
(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

(defun org-id-update-id-locations-recursive()
  "Calls org-id-update-id-locations with all org files in ~/Notes"
  (interactive)

  (defun is-not-hidden-dir (dir)
    (not (string-search "/." dir)))

  (setq org-files (directory-files-recursively
    "~/Notes" "\.org$" nil 'is-not-hidden-dir))

  (org-id-update-id-locations org-files)
  )

(use-package! org-super-links
  :custom (org-super-links :type git :host github :repo "toshism/org-super-links" :branch "develop")
  :bind (("C-c s s" . org-super-links-link)
         ("C-c s l" . org-super-links-store-link)
         ("C-c s C-l" . org-super-links-insert-link)))

(use-package! org-mouse
  :custom
  (org-mouse-features
   '(context-menu move-tree yank-link activate-stars activate-bullets activate-checkboxes)))

(setq! citar-bibliography '("~/Notes/bibliography.bib"))
(setq! org-cite-global-bibliography
 '("~/Notes/bibliography.bib"))


(require 'ox-publish)
(setq org-publish-project-alist
'(
    ("org-notes"
     :base-directory "~/org/"
     :base-extension "org"
     :publishing-directory "~/public_html/" :recursive t :publishing-function org-html-publish-to-html
     :headline-levels 4             ; Just the default for this project.
     :auto-preamble t
     )

))

(setq scroll-step 1)
(setq scroll-margin 7)

;; Always use unix line endings
(setq-default buffer-file-coding-system 'utf-8-unix)

;; Save buffers to their real file on auto-save.
(auto-save-visited-mode +1)

;; Turn auto complete off by default because it is annoying and not generally
;; needed for note taking.
(+company/toggle-auto-completion)

;; Weekly Notes Function
(defun goto-weekly-note ()
  "Create weekly note, or open it if it already exists"
  (interactive)
  (setq filename (concat "~/Notes/0_Inbox/" (format-time-string "%Y-Week-%U") ".org"))

   ;; Maybe create the file from a template.
   (unless (file-exists-p filename)
       ;; Create file from template.
       (setq template (format-time-string "* %Y Week %U%n"))
       (write-region template nil filename))

   (find-file filename))

;; Instructions pulled from org-roam docs for setting up the UI.
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))


(after! treemacs
  (setq treemacs-show-hidden-files nil)
)

;; Default to splitting to the right and below, which is much more intuitive.
(map! :desc "Split window" :n "C-w s" #'+evil/window-split-and-follow)
(map! :desc "Vertical split window" :n "C-w v" #'+evil/window-vsplit-and-follow)
