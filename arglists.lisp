(defpackage #:arglist-access
  (:use #:cl)
  (:export #:arglist))
(in-package #:arglist-access)

;;; API
(defun arglist (macro-name)
  (cond
    #+sbcl (t (sb-introspect:function-lambda-list (macro-function macro-name)))
    #+clisp (t (ext:arglist macro-name))
    (t nil)))

(defun (setf arglist) (new-val macro-name)
  (cond
    #+sbcl (t (setf (sb-kernel:%fun-lambda-list (macro-function macro-name)) new-val))
    #+clisp (t (sys::%putd macro-name (sys::make-macro (macro-function macro-name) new-val)))
    (t new-val)))
