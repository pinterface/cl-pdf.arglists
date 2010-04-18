(defpackage #:arglist-access
  (:use #:cl)
  (:export #:arglist))
(in-package #:arglist-access)

;;; API
(defun arglist (function)
  (cond
    #+sbcl (t (sb-introspect:function-lambda-list function))
    (t nil)))

(defun (setf arglist) (new-val function)
  (cond
    #+sbcl (t (setf (sb-kernel:%fun-lambda-list function) new-val))
    (t new-val)))
