(defsystem #:cl-pdf.arglists
  :depends-on (:closer-mop :alexandria :cl-pdf :cl-typesetting)
  :components ((:file "arglists")
               (:file "wrappers")
               (:file "cl-pdf")
               (:file "cl-typesetting")))
