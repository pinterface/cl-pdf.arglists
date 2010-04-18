;; Arglists for cl-typesetting
(defpackage #:cl-typesetting.fancy-arglists
  (:use #:cl #:typeset #:arglist-wrappers))
(in-package #:cl-typesetting.fancy-arglists)

(declare-object-wrapper with-document (pdf::document))

#+(or) (with-document () )

(declare-object-wrapper table (tt:table))

#+(or) (table () )

(declare-object-wrapper header-row (tt::table-row))
(declare-object-wrapper footer-row (tt::table-row))
(declare-object-wrapper row (tt::table-row))
(declare-object-wrapper cell (tt::table-cell))

(declare-object-wrapper compile-text (tt::text-style))
(declare-object-wrapper with-style (tt::text-style))
(declare-object-wrapper set-style (tt::text-style))
(declare-object-wrapper paragraph (tt::text-style))

#+(or) (compile-text () )
