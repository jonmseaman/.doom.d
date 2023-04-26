;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jon Seaman"
      user-mail-address "jonmseaman@live.com")

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
(setq org-directory "~/Notes/Org/")


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
  (setq org-directory "~/Notes/Org"
        org-agenda-files '("~/Notes/Org/Actions.org"
                           "~/Notes/Org/Projects.org")
        org-default-notes-file (expand-file-name "Actions.org" org-directory)
        org-log-done 'time
        org-agenda-start-with-follow-mode t
        org-agenda-follow-indirect t
        )

  (setq org-capture-templates '(("t" "Todo [INBOX in Projects.org]" entry
                                 (file+headline "~/Notes/Org/Projects.org" "INBOX")
                                 "* TODO %i%?")
                                ))

  (setq org-refile-targets '(("~/Notes/Org/Actions.org" :level . 2)
                             ("~/Notes/Org/Projects.org" :maxlevel . 3)))

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
           "PROJ(p)"             ; A project, which usually contains other tasks
           "EPIC(e)"             ; An epic, for agile-esque task management
           "MILESTONE(m)"        ; An agile milestone
           "STORY(s)"            ; A story, for software-esque task management
           "TODO(t)"             ; A task that needs doing & is ready to do
           "LOOP(r)"             ; A recurring task
           "PROG(p)"             ; A task that is in progress
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

  ;; org-agenda-custom-commands, partially adopted from:
  ;; https://protesilaos.com/codelog/2021-12-09-emacs-org-block-agenda/
  (setq org-agenda-custom-commands
        '(
          ("o" "Agenda Current Work Overview"
           (
            ;; Today view.
            (agenda ""
                    ((org-agenda-span 1)
                     (org-deadline-warning-days 0)
                     (org-agenda-block-separator nil)
                     (org-scheduled-past-days 0)
                     ;; We don't need the `org-agenda-date-today'
                     ;; highlight because that only has a practical
                     ;; utility in multi-day views.
                     (org-agenda-day-face-function (lambda (date) 'org-agenda-date))
                     (org-agenda-format-date "%A %-e %B %Y")
                     (org-agenda-overriding-header "\nToday's agenda\n")))
            ;; Upcoming (3 day)
            (agenda "" ((org-agenda-start-on-weekday nil)
                        (org-agenda-start-day "+1d")
                        (org-agenda-span 3)
                        (org-deadline-warning-days 0)
                        (org-agenda-block-separator nil)
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                        (org-agenda-overriding-header "\nNext three days\n")))
            ;; Upcoming (14 day)
            (agenda "" ((org-agenda-time-grid nil)
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
                        (org-agenda-overriding-header "\nUpcoming deadlines (+14d)\n")))
            ;; Current Tasks
            (tags-todo "active"
                       ((org-agenda-hide-tags-regexp "active")
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("TODO" "PROG" "LOOP")))
                        (org-agenda-overriding-header "\nCurrent Tasks\n"))
                       )
            ;; Current Projects
            (tags-todo "active"
                       ((org-agenda-hide-tags-regexp "active")
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("PROJ" "EPIC" "MILESTONE" "STORY")))
                        (org-agenda-overriding-header "\nCurrent Projects\n")
                        )
                       )
            ))

          ;; TODO: Make a review mode. This should include:
          ;; - Stuck projects
          ;; - Later/maybe
          ;; - Inbox
          ;; - etc...
          ("r" "Review List" ;; WIP Reviewe List
           (
            (tags-todo "-active"
                       (
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("WAIT")))
                        (org-agenda-overriding-header "\nWaiting List\n")
                        )
                       )))
          )
        )
  )




(use-package! org-mouse
  :custom
  (org-mouse-features
   '(context-menu move-tree yank-link activate-stars activate-bullets activate-checkboxes)))

(setq scroll-step 1)
(setq scroll-margin 7)

; Save open buffers and window positions.
; (desktop-save-mode 1)

; Always use unix line endings
(setq-default buffer-file-coding-system 'utf-8-unix)
