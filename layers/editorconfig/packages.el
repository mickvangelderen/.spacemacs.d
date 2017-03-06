(defconst editorconfig-packages
  '(
    editorconfig
    ))

(defun editorconfig/init-editorconfig ()
  (use-package editorconfig
    :init
    (editorconfig-mode t)
    :config
    (spacemacs|diminish editorconfig-mode "🖉" "EditorConfig")
    ))
