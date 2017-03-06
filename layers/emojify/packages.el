(defconst emojify-packages
  '(
    emojify
    ))

;; https://github.com/iqbalansari/emacs-emojify
(defun emojify/init-emojify ()
  (use-package emojify
    :init
    (global-emojify-mode)
    (emojify-set-emoji-styles '(github))
    (setq emojify-point-entered-behaviour 'uncover)
    (setq emojify-show-help nil)
    ))
