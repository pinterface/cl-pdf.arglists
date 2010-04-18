(defpackage #:arglist-wrappers
  (:use #:cl #:arglist-access)
  (:export #:declare-object-wrapper)
  (:import-from #:alexandria
                #:parse-ordinary-lambda-list)
  (:import-from #:closer-mop
                #:class-slots
                #:slot-definition-initargs
                #:slot-definition-initform))
(in-package #:arglist-wrappers)

(defun initargs-for-class (class)
  (loop :for slot :in (class-slots (find-class class))
        :for initarg = (first (slot-definition-initargs slot))
        :for initform = (slot-definition-initform slot)
        :when initarg
          :collect `((,initarg ,(gensym (symbol-name initarg)))
                     ,@(when initform (list initform)))))

#+(or) (initargs-for-class 'pdf::document)

(defun key-name (key)
  (if (listp key)
      (if (listp (first key))
          (first (first key))
          (first key))
      key))

(defun same-key-p (a b)
  (string= (key-name a) (key-name b)))

(defmacro declare-object-wrapper (macro-name (&rest classes))
  (let* ((function (macro-function macro-name))
         (fn-arglist (arglist function))
         (arglist (first fn-arglist)))
    (when (and fn-arglist (consp arglist))
      (let ((initargs (reduce #'nconc (mapcar #'initargs-for-class classes))))
        (multiple-value-bind (req opt rest key aok aux) (parse-ordinary-lambda-list arglist :normalize nil)
          `(eval-when (:load-toplevel :execute)
             (setf (arglist (macro-function ',macro-name))
                   '((,@req ,@opt ,@(when rest `(&rest ,rest))
                      ,(and (or key initargs) '&key)
                      ,@(remove-duplicates (append key initargs)
                                           :test #'same-key-p
                                           :from-end t)
                      ,@(when aok '(&allow-other-keys))
                      ,@aux)
                     ,@(rest fn-arglist)))))))))
