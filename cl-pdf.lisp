;; Arglists for cl-pdf
(defpackage #:cl-pdf.fancy-arglists
  (:use #:cl #:cl-pdf #:arglist-wrappers))
(in-package #:cl-pdf.fancy-arglists)

(declare-object-wrapper with-document (pdf::document))

#+(or) (with-document () )

(declare-object-wrapper with-page (pdf::page))

#+(or) (with-page () )
