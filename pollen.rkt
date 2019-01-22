#lang racket/base
(require
  pollen/decode
  pollen/misc/tutorial
  txexpr
  libuuid)

;the root function stuff
(provide root)
(define (root . elements)
  (txexpr 'root empty (decode-elements elements
                                       #:txexpr-elements-proc decode-paragraphs
                                       #:string-proc (compose1 smart-quotes smart-dashes))))

;----------constants-----------
(provide sep
         mn-label)
;Symbol to separate items in menu
(define sep
  '(span [[class "red"]] "‡"))

;Symbol to note margin notes in small screens
(define mn-label
  '(span [[class "red"]] "※"))



;--------------tags----------------
(provide sc
         highlight
         margin-note
         margin-figure
         hyperlink)

;small caps
(define (sc . elements)
  (txexpr 'span '((class "smallcaps")) elements))

;highlight coloring
(define (highlight . elements)
  (txexpr 'span '((class "red")) elements))

;margin-notes
(define (margin-note . content)
  (define refid (uuid-generate))
  `(@ (label [[for ,refid] [class "margin-toggle"]] ,mn-label)
      (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
      (span [[class "marginnote"]] ,@content)))

;proper margin figures
(define (margin-figure source . caption)
  (define refid (uuid-generate))
  `(@ (label [[for ,refid] [class "margin-toggle"]] ,mn-label)
      (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
      (span [[class "marginnote"]] (img [[src ,source]]) ,@caption)))

(provide fig)
(define (fig source . caption)
  (txexpr 'figure `((img [[src ,source]]))))

;hyperlinks!
(define (hyperlink url . desc)
  (txexpr 'a `((href ,url)) `(,@desc)))