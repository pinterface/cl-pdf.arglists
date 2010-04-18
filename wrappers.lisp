(defpackage #:arglist-wrappers
  (:use #:cl #:arglist-access)
  (:export #:declare-object-wrapper)
  (:import-from #:alexandria
                #:parse-ordinary-lambda-list))
(in-package #:arglist-wrappers)

(defun initargs-for-class (class)
  (loop :for slot :in (closer-mop:class-slots (find-class class))
        :append (closer-mop:slot-definition-initargs slot)))

#+(or) (initargs-for-class 'pdf::document)

(defmacro declare-object-wrapper (macro-name (&rest classes))
  (let* ((function (macro-function macro-name))
         (fn-arglist (arglist function))
         (arglist (first fn-arglist)))
    (when (and fn-arglist (consp arglist))
      (let ((initargs (remove-duplicates (reduce #'nconc (mapcar #'initargs-for-class classes)))))
        (multiple-value-bind (req opt rest key aok aux) (parse-ordinary-lambda-list arglist :normalize nil)
          `(eval-when (:load-toplevel :execute)
             (setf (arglist (macro-function ',macro-name))
                   '((,@req ,@opt ,@(when rest `(&rest ,rest))
                      ,(and (or key initargs) '&key)
                      ,@(remove-duplicates `(,@key ,@(mapcar (lambda (k) `((,k ,(gensym)))) initargs))
                                           :test #'string=
                                           :from-end t
                                           :key (lambda (key) (if (listp key)
                                                                  (if (listp (first key))
                                                                      (first (first key))
                                                                      (first key))
                                                                  key)))
                      ,@(when aok '(&allow-other-keys))
                      ,@aux)
                     ,@(rest fn-arglist)))))))))
