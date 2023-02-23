;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; use-package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;; https://ianyepan.github.io/posts/setting-up-use-package/


;; https://ianyepan.github.io/posts/setting-up-use-package/
(require 'package)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)




;; должен быть добавлен
;;straight-use-package
;; https://github.com/radian-software/straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq package-enable-at-startup nil)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; base settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(setq tty-menu-open-use-tmm t)
(global-set-key (kbd "C-x }") 'menu-bar-open)




;;Не на­до мне со­об­щать, что у стро­ки есть про­дол­же­ние. Прос­то по­ка­зы­вай про­дол­же­ние на сле­ду­ющей стро­ке:
(setq-default truncate-lines t)

;; Electric-modes settings
;;В новых версиях Emacs внедрили electic-mod'ы. Первый из них автоматически расставляет
;;отступы (работает из рук вон плохо), второй — закрывает скобки, кавычки и т.д.
;;Отключим первый (Python программисты меня поймут...) и включим второй:

;; автозакрытие {},[],() с переводом курсора внутрь скобок
;;(electric-indent-mode 1) ;; отключить индентацию  electric-indent-mod'ом (default in Emacs-24.4

;;Хотим иметь возможность удалить выделенный текст при вводе поверх?
(delete-selection-mode t)

;;Плавный скроллинг:
(setq scroll-step               1) ;; вверх-вниз по 1 строке
(setq scroll-margin            10) ;; сдвигать буфер верх/вниз когда курсор в 10 шагах от верхней/нижней границы
(setq scroll-conservatively 10000)

;;Общий с ОС буфер обмена:
(setq x-select-enable-clipboard t)

;; Fringe settings
(fringe-mode '(8 . 0)) ;; органичиталь текста только слева
(setq-default indicate-empty-lines t) ;; отсутствие строки выделить глифами рядом с полосой с номером строки
(setq-default indicate-buffer-boundaries 'left) ;; индикация только слева

;; Line wrapping
(setq word-wrap          t) ;; переносить по словам
(global-visual-line-mode t)

;; Highlight search resaults
(setq search-highlight        t)
(setq query-replace-highlight t)

;;полный экран при запуске
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

;;https://github.com/ch11ng/exwm/wiki

;;end exwm++++


(use-package centaur-tabs
  :load-path "~/.emacs.d/main_packages/centaur-tabs"
  :config
  (setq centaur-tabs-style "bar"
        centaur-tabs-height 32
        centaur-tabs-set-icons t
        centaur-tabs-set-modified-marker t
        centaur-tabs-show-navigation-buttons t
        centaur-tabs-set-bar 'under
        x-underline-at-descent-line t)
  (centaur-tabs-headline-match)
  ;; (setq centaur-tabs-gray-out-icons 'buffer)
  ;; (centaur-tabs-enable-buffer-reordering)
  ;; (setq centaur-tabs-adjust-buffer-order t)
  (centaur-tabs-mode t)
  (setq uniquify-separator "/")
  (setq uniquify-buffer-name-style 'forward)
  (defun centaur-tabs-buffer-groups ()
    "`centaur-tabs-buffer-groups' control buffers' group rules.

 Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
 All buffer name start with * will group to \"Emacs\".
 Other buffer group by `centaur-tabs-get-group-name' with project name."
    (list
     (cond
      ;; ((not (eq (file-remote-p (buffer-file-name)) nil))
      ;; "Remote")
      ((or (string-equal "*" (substring (buffer-name) 0 1))
           (memq major-mode '(magit-process-mode
                              magit-status-mode
                              magit-diff-mode
                              magit-log-mode
                              magit-file-mode
                              magit-blob-mode
                              magit-blame-mode
                              )))
       "Emacs")
      ((derived-mode-p 'prog-mode)
       "Editing")
      ((derived-mode-p 'dired-mode)
       "Dired")
      ((memq major-mode '(helpful-mode
                          help-mode))
       "Help")
      ((memq major-mode '(org-mode
                          org-agenda-clockreport-mode
                          org-src-mode
                          org-agenda-mode
                          org-beamer-mode
                          org-indent-mode
                          org-bullets-mode
                          org-cdlatex-mode
                          org-agenda-log-mode
                          diary-mode))
       "OrgMode")
      (t
       (centaur-tabs-get-group-name (current-buffer))))))
  :hook
  (dashboard-mode . centaur-tabs-local-mode)
  (term-mode . centaur-tabs-local-mode)
  (calendar-mode . centaur-tabs-local-mode)
  (org-agenda-mode . centaur-tabs-local-mode)
  (helpful-mode . centaur-tabs-local-mode)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward)
  ("C-c t s" . centaur-tabs-counsel-switch-group)
  ("C-c t p" . centaur-tabs-group-by-projectile-project)
  ("C-c t g" . centaur-tabs-group-buffer-groups))
;;(:map evil-normal-state-map
;;("g t" . centaur-tabs-forward)
;;("g T" . centaur-tabs-backward)))


;; Передвижение границ окон и разделителей, работает только в
;; графическом режиме а не в терминале

;;         ^
;;         k                  Советы: Клавиша h находится слева и перемещает влево.
;;   < h       l >            Клавиша l находится справа и перемещает вправо.
;;         j                  Клавиша j похожа на стрелку "вниз".
;;         v

(global-set-key (kbd "S-C-h") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-l") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-k") 'shrink-window)
(global-set-key (kbd "S-C-j") 'enlarge-window)




;;(add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-application-framework/")
;;(require 'eaf)
;;(require 'eaf-terminal)






;;(prefer-coding-system 'utf-8)
;;(set-charset-priority 'unicode)
;;(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)



;; Don't ask about killing process buffers on shutdown
;; https://emacs.stackexchange.com/questions/14509/kill-process-buffer-without-confirmation
(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))

;; Use bash.. zsh causes slowness in projectile: https://github.com/syl20bnr/spacemacs/issues/4207
(setq shell-file-name "/bin/bash")


;; allow typing y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

(require 'dimmer)
(dimmer-configure-which-key)
(dimmer-configure-helm)
(dimmer-mode t)


;;В последней версии Prelude flyspell можно легко отключить с помощью
;; отключен
(setq prelude-flyspell nil)

;; Bookmark settings
(require 'bookmark)
(setq bookmark-save-flag t) ;; автоматически сохранять закладки в файл
(when (file-exists-p (concat user-emacs-directory "bookmarks"))
  (bookmark-load bookmark-default-file t)) ;; попытаться найти и открыть файл с закладками
(global-set-key (kbd "<f3>") 'bookmark-set) ;; создать закладку по F3
(global-set-key (kbd "<f4>") 'bookmark-jump) ;; прыгнуть на закладку по F4
(global-set-key (kbd "<f5>") 'bookmark-bmenu-list) ;; открыть список закладок
;;(setq bookmark-default-file (concat user-emacs-directory "bookmarks")) ;; хранить закладки в файл bookmarks в .emacs.d



;;(require 'neotree)
;;(global-set-key [f8] 'neotree-toggle)

(use-package minions
  :config
  (minions-mode 1))


;; telephone-line
;; https://github.com/dbordak/telephone-line
(require 'telephone-line)
(telephone-line-mode t)
;;;раскраска

(setq telephone-line-primary-left-separator 'telephone-line-cubed-left
      telephone-line-secondary-left-separator 'telephone-line-cubed-hollow-left
      telephone-line-primary-right-separator 'telephone-line-cubed-right
      telephone-line-secondary-right-separator 'telephone-line-cubed-hollow-right)
(setq telephone-line-height 24
      telephone-line-evil-use-short-tag t)
;;end telephone-line



;; Buffer Selection and ibuffer settings
(require 'bs)
(require 'ibuffer)
(defalias 'list-buffers 'ibuffer) ;; отдельный список буферов при нажатии C-x C-b
(global-set-key (kbd "<F-2>") 'bs-show) ;; запуск buffer selection кнопкой F2



;; https://github.com/emacs-dashboard/emacs-dashboard


(require 'dashboard)
(dashboard-setup-startup-hook)
;;Надпись
(setq dashboard-banner-logo-title "Best IDE Emacs.")
;;использовать с ('projectile)
;;(setq dashboard-projects-switch-function 'projectile-persp-switch-project)
(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
;;
(setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)
                        (agenda . 5)
                        (registers . 5)))







;;https://github.com/Malabarba/beacon
;;Всякий раз, когда окно прокручивается, над вашим курсором будет светиться свет.
(add-to-list 'load-path "~/.emacs.d/beacon/")
(require 'beacon)
(beacon-mode 1)

;;
;; (setq helm-projectile-fuzzy-match nil)
;;(require 'helm-projectile)
;;(helm-projectile-on)

;;IDO



;;end ido+++++



;;с одним universal-argument ( C-u) Emacs перезапускается с --debug-initфлаг
;;с двумя universal-argument ( C-u C-u) Emacs перезапускается с -Qфлаг
;;с тремя universal-argument ( C-u C-u C-u) пользователю предлагается ввести аргументы

(require 'restart-emacs)
(setq restart-emacs-restore-frames t)
;;(global-set-key [f7] 'restart-emacs)


;;история команд
(use-package command-log-mode
  :bind (("C-c C-*" . clm/open-command-log-buffer)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;автозаполнение и elpy python and company
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; https://medium.com/analytics-vidhya/managing-a-python-development-environment-in-emacs-43897fd48c6a
;; Elpy
(use-package elpy
  :straight t
  :bind
  (:map elpy-mode-map
        ("C-M-n" . elpy-nav-forward-block)
        ("C-M-p" . elpy-nav-backward-block))
  :hook ((elpy-mode . (lambda ()
                        (add-hook 'before-save-hook
                                  'elpy-format-code nil t)))
         (elpy-mode . flycheck-mode)
         (elpy-mode . (lambda ()
                        (set (make-local-variable 'company-backends)
                             '((elpy-company-backend :with company-yasnippet))))))
  :init
  (elpy-enable)
  :config
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
                                        ; fix for MacOS, see https://github.com/jorgenschaefer/elpy/issues/1550
  (setq elpy-shell-echo-output nil)
  (setq elpy-rpc-python-command "python3")
  (setq elpy-rpc-timeout 2))

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

;;Company

(use-package company
  :straight t
  :diminish company-mode
  :init
  (global-company-mode)
  :config
  ;; set default `company-backends'
  (setq company-backends
        '((company-files          ; files & directory
           company-keywords       ; keywords
           company-capf)                ; completion-at-point-functions
          (company-abbrev company-dabbrev)
          (company-capf);;завершение org-roam
          ))

  (use-package company-statistics
    :straight t
    :init
    (company-statistics-mode))

  (use-package company-web
    :straight t)

  (use-package company-try-hard
    :straight t
    :bind
    (("C-<tab>" . company-try-hard)
     :map company-active-map
     ("C-<tab>" . company-try-hard)))

  ;; https://github.com/company-mode/company-quickhelp
  (use-package company-quickhelp
    :straight t
    :config
    (company-quickhelp-mode))
  )

(eval-after-load 'company
  '(define-key company-active-map (kbd "C-c h") #'company-quickhelp-manual-begin))


(use-package prescient
  :config
  (setq prescient-history-length 5))

(use-package ivy-prescient
  :config
  (ivy-prescient-mode))

(use-package company-prescient
  :config
  (company-prescient-mode))






;; end python elpy



(use-package markdown-mode
  :straight t
  :mode
  (("\\.md\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode)))


(use-package flycheck
  :straight t
  :init
  (global-flycheck-mode))


;; https://github.com/flycheck/flycheck-pos-tip
;; разобраться
(use-package flycheck-tip
  ;;:config
  ;;(flycheck-pos-tip-mode)
  :straight t
  :bind
  (("C-c C-n" . error-tip-cycle-dwim)
   ("C-c C-z" . error-tip-cycle-dwim-reverse))
  )

;; и автоматическое распознавание файлов "PKGBUILD":
(use-package pkgbuild-mode
  :straight t
  :mode "/PKGBUILD$")


;;treemacs******************
;;*************************
;;*************************
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name "~/.cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

;;(use-package treemacs-evil
;; :after (treemacs evil)
;; :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :ensure t
  :config (treemacs-set-scope-type 'Tabs))


;; Дополнительные настройки
;; https://github.com/Alexander-Miller/treemacs#navigation-without-projects-and-workspaces
(treemacs-project-follow-mode +1)
;;разворачивать одним щелчком
(with-eval-after-load 'treemacs
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))


;;end treemacs*********************************
;;*********************************************
;;*****************************************


;;https://github.com/pashinin/workgroups2
(require 'workgroups2)
;; Change prefix key (before activating WG)
(setq wg-prefix-key "C-c z")

(workgroups-mode 1)   ; put this one at the bottom of .emacs
(setq wg-session-file "~/.emacs.d/.emacs_workgroups")
;;Поддержка специального буфера
;;Вот минимальный пример кода для поддержки ivy-occur-grep-mode,
(with-eval-after-load 'workgroups2
  ;; provide major mode, package to require, and functions
  (wg-support 'ivy-occur-grep-mode 'ivy
    `((serialize . ,(lambda (_buffer)
                      (list (base64-encode-string (buffer-string) t))))
      (deserialize . ,(lambda (buffer _vars)
                        (switch-to-buffer (wg-buf-name buffer))
                        (insert (base64-decode-string (nth 0 _vars)))
                        ;; easier than `ivy-occur-grep-mode' to set up
                        (grep-mode)
                        ;; need return current buffer at the end of function
                        (current-buffer))))))






;;Запоминание недавно отредактированных файлов
(recentf-mode 1)
;;запоминание вводимых команд
;; Save what you enter into minibuffer prompts
(setq history-length 25)
(savehist-mode 1)
;;Запоминание последнего места в файле
(save-place-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; programming
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; подствечивает круглые скобки
(require 'highlight-parentheses)
;; везде
(add-hook 'prog-mode-hook #'highlight-parentheses-mode)
;; в минибуфере
(add-hook 'minibuffer-setup-hook #'highlight-parentheses-minibuffer-setup)

;;activate show paren
(show-paren-mode 1)
;;(setq show-paren-style 'expression) ; подсвечивает блоки, но раздражает

;; нажимаешь на скобку, выделяет парную
(add-to-list 'load-path "~/.emacs.d/main_packages/rainbow-delimiters/")
(require 'rainbow-delimiters)
(require 'highlight)

(rainbow-delimiters-mode +1)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)





(use-package web-mode
  :config
  (setq web-mode-engines-alist '(("django" . "\\.html\\'"))
        web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-style-padding 1
        web-mode-script-padding 1
        web-mode-block-padding 0)
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  ;; integration with smartparens-mode
  (setq web-mode-enable-auto-pairing nil)
  (defun sp-web-mode-is-code-context (id action context)
    (and (eq action 'insert)
         (not (or (get-text-property (point) 'part-side)
                  (get-text-property (point) 'block-side)))))
  (sp-local-pair 'web-mode "<" nil :when '(sp-web-mode-is-code-context)))




(setq imenu-auto-rescan      t) ;; автоматически обновлять список функций в буфере
(setq imenu-use-popup-menu nil) ;; диалоги Imenu только в минибуфере
(global-set-key (kbd "<f6>") 'imenu) ;; вызов Imenu на F6


(use-package avy
  :bind (("C-g" . 'avy-goto-line)
         ("C-'" . 'avy-goto-char-2)))

















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;шаблон, добавив запись в org-structure-template-alist
;;то что ковычки на второй строке, так нужно, что бы курсор был между тегами
;; https://emacs.stackexchange.com/questions/40571/how-to-set-a-short-cut-for-begin-src-end-src
(add-to-list 'org-structure-template-alist '("p" . "src python
"))

(add-to-list 'org-structure-template-alist '("j" . "src js
"))

(require 'org-preview-html)
;;(org-preview-html-mode 1)
(global-set-key (kbd "<f9>") 'org-preview-html-mode)

(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode))

(use-package org-fancy-priorities
  :ensure t
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))

(use-package org-pretty-tags
  :diminish org-pretty-tags-mode
  :ensure t
  :config
  (setq org-pretty-tags-surrogate-strings
        '(("work"  . "⚒")))

  (org-pretty-tags-global-mode))

;;work
;;Скрывать *, ~а также /в тексте орг.
(setq org-hide-emphasis-markers t)



;; set maximum indentation for description lists
(setq org-list-description-max-indent 5)

;; prevent demoting heading also shifting text inside sections
(setq org-adapt-indentation nil)

;;Подсветка синтаксиса в блоке #+begin_src
(setq org-src-fontify-natively t)




;; украшение заголовков
;; https://github.com/integral-dw/org-superstar-mode
(require 'org-superstar)
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))

;; нижнее подчёркивание отображается верно
;;https://stackoverflow.com/questions/698562/disabling-underscore-to-subscript-in-emacs-org-mode-export
(setq org-export-with-sub-superscripts nil)



;;дополнительные настройки
;; проработать
;;https://hugocisneros.com/org-config/
;;https://github.com/james-stoup/emacs-org-mode-tutorial
;; org agenta
;;https://orgmode.org/worg/org-tutorials/orgtutorial_dto.html
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"))))

;;Это поэтому я не могу установить заголовок для DONEесли дети не DONE
(setq-default org-enforce-todo-dependencies t)


;;«TODO» лица и настройки экспорта
;;Это устанавливает цвета ключевых слов. Не так важно, потому что я также прячу их с помощью org-superstar. Ключевые слова по-прежнему отображаются при наведении на них курсора.
(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))
;; I don't wan't the keywords in my exports by default
(setq-default org-export-with-todo-keywords nil)


;;Общий стиль
;;Пропорциональная ширина
(defun my/buffer-face-mode-variable ()
  "Set font to a variable width (proportional) fonts in current buffer"
  (interactive)
  (setq buffer-face-mode-face '(:family "Roboto Slab"
                                        :height 150
                                        :width normal))
  (buffer-face-mode))

;;Настройка лиц
(defun my/set-general-faces-org ()
  (my/buffer-face-mode-variable)
  (setq line-spacing 0.1
        org-pretty-entities t
        org-startup-indented t
        org-adapt-indentation nil)
  (variable-pitch-mode +1)
  (mapc
   (lambda (face) ;; Other fonts that require it are set to fixed-pitch.
     (set-face-attribute face nil :inherit 'fixed-pitch))
   (list 'org-block
         'org-table
         'org-verbatim
         'org-block-begin-line
         'org-block-end-line
         'org-meta-line
         'org-date
         'org-drawer
         'org-property-value
         'org-special-keyword
         'org-document-info-keyword))
  (mapc ;; This sets the fonts to a smaller size
   (lambda (face)
     (set-face-attribute face nil :height 0.8))
   (list 'org-document-info-keyword
         'org-block-begin-line
         'org-block-end-line
         'org-meta-line
         'org-drawer
         'org-property-value
         )))


;;Эта функция устанавливает цвета и размер заголовков.


(defun my/set-specific-faces-org ()
  (set-face-attribute 'org-code nil
                      :inherit '(shadow fixed-pitch))
  ;; Without indentation the headlines need to be different to be visible
  (set-face-attribute 'org-level-1 nil
                      :height 1.25
                      :foreground "#BEA4DB")
  (set-face-attribute 'org-level-2 nil
                      :height 1.15
                      :foreground "#A382FF"
                      :slant 'italic)
  (set-face-attribute 'org-level-3 nil
                      :height 1.1
                      :foreground "#5E65CC"
                      :slant 'italic)
  (set-face-attribute 'org-level-4 nil
                      :height 1.05
                      :foreground "#ABABFF")
  (set-face-attribute 'org-level-5 nil
                      :foreground "#2843FB")
  (set-face-attribute 'org-date nil
                      :foreground "#ECBE7B"
                      :height 0.8)
  (set-face-attribute 'org-document-title nil
                      :foreground "DarkOrange3"
                      :height 1.3)
  (set-face-attribute 'org-ellipsis nil
                      :foreground "#4f747a" :underline nil)
  (set-face-attribute 'variable-pitch nil
                      :family "Roboto Slab" :height 1.2))



;;Повестка дня организации


(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator #x2501
      org-agenda-compact-blocks t
      org-agenda-start-with-log-mode t)
(with-eval-after-load 'org-journal
  (define-key org-journal-mode-map (kbd "<C-tab>") 'yas-expand))
(setq org-agenda-clockreport-parameter-plist
      (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))
(setq org-agenda-deadline-faces
      '((1.0001 . org-warning)              ; due yesterday or before
        (0.0    . org-upcoming-deadline)))  ; due today or later




(setq-default org-icalendar-include-todo t)
(setq org-combined-agenda-icalendar-file "~/org/calendar.ics")
(setq org-icalendar-combined-name "Hugo Org")
(setq org-icalendar-use-scheduled '(todo-start event-if-todo event-if-not-todo))
(setq org-icalendar-use-deadline '(todo-due event-if-todo event-if-not-todo))
(setq org-icalendar-timezone "Europe/Paris")
(setq org-icalendar-store-UID t)
(setq org-icalendar-alarm-time 30)
(setq french-holiday
      '((holiday-fixed 1 1 "Jour de l'an")
        (holiday-fixed 5 8 "Victoire 45")
        (holiday-fixed 7 14 "Fête nationale")
        (holiday-fixed 8 15 "Assomption")
        (holiday-fixed 11 1 "Toussaint")
        (holiday-fixed 11 11 "Armistice 18")
        (holiday-easter-etc 1 "Lundi de Pâques")
        (holiday-easter-etc 39 "Ascension")
        (holiday-easter-etc 50 "Lundi de Pentecôte")
        (holiday-fixed 1 6 "Épiphanie")
        (holiday-fixed 2 2 "Chandeleur")
        (holiday-fixed 2 14 "Saint Valentin")
        (holiday-fixed 5 1 "Fête du travail")
        (holiday-fixed 5 8 "Commémoration de la capitulation de l'Allemagne en 1945")
        (holiday-fixed 6 21 "Fête de la musique")
        (holiday-fixed 11 2 "Commémoration des fidèles défunts")
        (holiday-fixed 12 25 "Noël")
        ;; fêtes à date variable
        (holiday-easter-etc 0 "Pâques")
        (holiday-easter-etc 49 "Pentecôte")
        (holiday-easter-etc -47 "Mardi gras")
        (holiday-float 6 0 3 "Fête des pères") ;; troisième dimanche de juin
        ;; Fête des mères
        (holiday-sexp
         '(if (equal
               ;; Pentecôte
               (holiday-easter-etc 49)
               ;; Dernier dimanche de mai
               (holiday-float 5 0 -1 nil))
              ;; -> Premier dimanche de juin si coïncidence
              (car (car (holiday-float 6 0 1 nil)))
            ;; -> Dernier dimanche de mai sinon
            (car (car (holiday-float 5 0 -1 nil))))
         "Fête des mères")))
(setq calendar-date-style 'european
      holiday-other-holidays french-holiday
      calendar-mark-holidays-flag t
      calendar-week-start-day 1
      calendar-mark-diary-entries-flag nil)



;;Супер повестка дня
;;https://github.com/alphapapa/org-super-agenda
(require 'org-super-agenda)
(org-super-agenda-mode 1)



(setq org-agenda-custom-commands
      '(("z" "Hugo view"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                                :time-grid t
                                :date today
                                :todo "TODAY"
                                :scheduled today
                                :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '(;; Each group has an implicit boolean OR operator between its selectors.
                          (:name "Today"
                                 :deadline today
                                 :face (:background "black"))
                          (:name "Passed deadline"
                                 :and (:deadline past :todo ("TODO" "WAITING" "HOLD" "NEXT"))
                                 :face (:background "#7f1b19"))
                          (:name "Work important"
                                 :and (:priority>= "B" :category "Work" :todo ("TODO" "NEXT")))
                          (:name "Work other"
                                 :and (:category "Work" :todo ("TODO" "NEXT")))
                          (:name "Important"
                                 :priority "A")
                          (:priority<= "B"
                                       ;; Show this section after "Today" and "Important", because
                                       ;; their order is unspecified, defaulting to 0. Sections
                                       ;; are displayed lowest-number-first.
                                       :order 1)
                          (:name "Papers"
                                 :file-path "~/.emacs.d/main_packages/org-roam-file")
                          (:name "Waiting"
                                 :todo "WAITING"
                                 :order 9)
                          (:name "On hold"
                                 :todo "HOLD"
                                 :order 10)))))))))
(add-hook 'org-agenda-mode-hook 'org-super-agenda-mode)


;;время отображается в виде столбца:
;; Set default column view headings: Task Total-Time Time-Stamp
(setq org-columns-default-format "%50ITEM(Task) %10CLOCKSUM %16TIMESTAMP_IA")


;;Ссылка на организацию и Bibtex



;;по этой ссылке
;; https://orgmode.org/worg/org-tutorials/orgtutorial_dto.html
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)


;;перенос строк
(add-hook 'org-mode-hook (lambda ()
                           (auto-fill-mode 1)))





;;https://github.com/org-roam/org-roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/.emacs.d/main_packages/org-roam-files"))
  :bind (("C-x n l" . org-roam-buffer-toggle)
         ("C-x n f" . org-roam-node-find)
         ("C-x n g" . org-roam-graph)
         ("C-x n i" . org-roam-node-insert)
         ("C-x n c" . org-roam-capture)
         ;; Dailies
         ("C-x n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(require 'org-roam-export)


;;импортируем подстветку синтаксиса.
;;https://github.com/hniksic/emacs-htmlize
(package-install 'htmlize)

;;https://github.com/bastibe/org-journal
;;(require 'org-journal)

(use-package org-journal
  :load-path "~/.emacs.d/main_packages/org-journal"
  :bind
  ("C-x n o" . org-journal-new-entry)
  :custom

  (org-journal-date-prefix "#+title: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-date-format "%A, %d %B %Y")
  :config
  (setq org-journal-list-default-directory "~/.emacs.d/main_packages/org-journal-files/"))






;;Закрыть журнал при выходе
;; C-x C-s
(defun org-journal-save-entry-and-exit()
  "Simple convenience function.
    Saves the buffer of the current day's entry and kills the window
    Similar to org-capture like behavior"
  (interactive)
  (save-buffer)
  (kill-buffer-and-window))

(add-hook 'org-journal-mode-hook
          (lambda ()
            (define-key org-journal-mode-map
              (kbd "C-x C-s") 'org-journal-save-entry-and-exit)))

(setq org-journal-enable-agenda-integration t
      org-icalendar-store-UID t
      org-icalendar-include-todo "all"
      org-icalendar-combined-agenda-file "~/.emacs.d/main_packages/org-journal.ics")

;;https://github.com/jrblevin/deft
(use-package deft
  :bind ("<f8>" . deft)
  :commands (deft)
  :config (setq deft-directory "~/.emacs.d/main_packages/org-roam-files"

                deft-extensions '("org" "md")))
(setq deft-use-filename-as-title t)



;;https://github.com/Kungsgeten/org-brain
(use-package org-brain :ensure t
  :init
  (setq org-brain-path "~/.emacs.d/main_packages/org-brain-articles")
  ;; For Evil users
  (with-eval-after-load 'evil
    (evil-set-initial-state 'org-brain-visualize-mode 'emacs))
  :config
  (bind-key "C-c b" 'org-brain-prefix-map org-mode-map)
  (setq org-id-track-globally t)
  (setq org-id-locations-file "~/.emacs.d/.org-id-locations")
  (add-hook 'before-save-hook #'org-brain-ensure-ids-in-buffer)
  ;;(push '("b" "Brain" plain (function org-brain-goto-end)
       ;;   "* %i%?" :empty-lines 1)
      ;;  org-capture-templates)
  (setq org-brain-visualize-default-choices 'all)
  (setq org-brain-title-max-length 12)
  (setq org-brain-include-file-entries nil
        org-brain-file-entries-use-title nil))

;; Allows you to edit entries directly from org-brain-visualize
(use-package polymode
  :config
  (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))
(setq org-default-notes-file (concat org-directory "~/org/notes.org"))


;;https://github.com/snosov1/toc-org/tree/bf2e4b358efbd860ecafe6e74776de0885d9d100
;;toc-orgпомогает вам иметь актуальное оглавление в org-файлах без экспорта (полезно в первую очередь для файлов readme на GitHub).
(if (require 'toc-org nil t)
    (progn
      (add-hook 'org-mode-hook 'toc-org-mode)

      ;; enable in markdown, too
      (add-hook 'markdown-mode-hook 'toc-org-mode)
      (define-key markdown-mode-map (kbd "\C-c\C-o") 'toc-org-markdown-follow-thing-at-point))
  (warn "toc-org not found"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;            js settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; js settings
;; https://www.chadstovern.com/javascript-in-emacs-revisited/





(require 'prettier-js)
(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)

;;https://emacs.cafe/emacs/javascript/setup/2017/04/23/emacs-setup-javascript.html
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; Better imenu
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)


(require 'nodejs-repl)
(add-hook 'js-mode-hook
          (lambda ()
            (define-key js-mode-map (kbd "C-x C-e") 'nodejs-repl-send-last-expression)
            (define-key js-mode-map (kbd "C-c C-j") 'nodejs-repl-send-line)
            (define-key js-mode-map (kbd "C-c C-r") 'nodejs-repl-send-region)
            (define-key js-mode-map (kbd "C-c C-c") 'nodejs-repl-send-buffer)
            (define-key js-mode-map (kbd "C-c C-l") 'nodejs-repl-load-file)
            (define-key js-mode-map (kbd "C-c C-z") 'nodejs-repl-switch-to-repl)))
