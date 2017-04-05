;;; packages.el --- flow-type layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Jonathan del Strother <jdelStrother@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst flow-type-packages
  '(company
    (company-flow :toggle (configuration-layer/package-usedp 'company))
    (flycheck-flow :toggle (configuration-layer/package-usedp 'flycheck))
    eldoc
    js2-mode))

(defun flow-type/add-mode-integrations(mode)
  (spacemacs/declare-prefix-for-mode mode "mf" "flow" "flow type checker commands")
  (spacemacs/set-leader-keys-for-major-mode mode
    "fs" 'flow-type/show-start-server
    "fc" 'flow-type/status
    "fC" 'flow-type/check
    "fd" 'flow-type/jump-to-definition
    "ft" 'flow-type/show-type-at-cursor)

  (when (eq 'process flow-type-no-auto-start)
    (add-hook mode 'flow-type/ensure-server-buffer))
  (add-to-list (intern (format "spacemacs-jump-handlers-%S" mode)) 'flow-type/jump-to-definition))

(defun flow-type/post-init-eldoc()
  (when (configuration-layer/package-usedp 'js2-mode)
    (push 'flow-type/enable-eldoc js2-mode-hook))
  (when (configuration-layer/layer-usedp 'react)
    (push 'flow-type/enable-eldoc react-mode-hook)))

(defun flow-type/post-init-company()
  (spacemacs|add-company-backends :backends company-flow :modes js2-mode react-mode))

(with-eval-after-load 'compile
  (add-to-list 'compilation-error-regexp-alist-alist
               '(flow "^\\([^:\n]+\\):\\([0-9]+\\)$" 1 2))
  (add-to-list 'compilation-error-regexp-alist 'flow))

(defun flow-type/post-init-js2-mode()
  (flow-type/add-mode-integrations 'js2-mode))

;; There's no flow-type/post-init-react hook, so we have to do this dance:
(defun flow-type/pseudo-post-init-react-mode()
  (flow-type/add-mode-integrations 'react-mode)
  (remove-hook 'react-mode-hook 'flow-type/pseudo-post-init-react-mode))
(add-hook 'react-mode-hook 'flow-type/pseudo-post-init-react-mode)

(defun flow-type/init-company-flow ()
  (use-package company-flow
    :defer t
    :config
    (when (configuration-layer/layer-usedp 'react)
      (push 'react-mode company-flow-modes))))

(defun flow-type/init-flycheck-flow()
  (with-eval-after-load 'flycheck
    (use-package flycheck-flow
      :config
      (progn
        ;; Don't run flow if there's no @flow pragma
        (custom-set-variables '(flycheck-javascript-flow-args (quote ("--respect-pragma"))))
        (when flow-type-no-auto-start
          (add-to-list 'flycheck-javascript-flow-args "--no-auto-start"))
        ;; Run flow in react-mode files
        (flycheck-add-mode 'javascript-flow 'react-mode)
        ;; After running js-flow, run js-eslint
        (flycheck-add-next-checker 'javascript-flow 'javascript-eslint)
      ))))
