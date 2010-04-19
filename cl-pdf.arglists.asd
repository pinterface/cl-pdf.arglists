(defsystem #:cl-pdf.arglists
  :depends-on (:closer-mop :alexandria :cl-pdf :cl-typesetting)
  :serial t
  :components ((:file "arglists")
               (:file "wrappers")
               (:file "cl-pdf")
               (:file "cl-typesetting")))
