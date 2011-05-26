(import foreign)

(foreign-declare "#include <libfprint/fprint.h>")

(define-syntax c-constant
  (syntax-rules ()
    ([_ name type] (define name (foreign-value name type)))))

;;; Constantes
;; (c-constant LEFT_THUMB int)
;; (c-constant LEFT_INDEX int)
;; (c-constant LEFT_MIDDLE int)
;; (c-constant LEFT_RING int)
;; (c-constant LEFT_LITTLE int)
;; (c-constant RIGHT_THUMB int)
;; (c-constant RIGHT_INDEX int)
;; (c-constant RIGHT_MIDDLE int)
;; (c-constant RIGHT_RING int)
;; (c-constant RIGHT_LITTLE int)

(define LEFT-HAND
  '(LEFT-THUMB LEFT-INDEX LEFT-MIDDLE LEFT-RING LEFT-LITTLE))

(define RIGHT-HAND
  '(RIGHT-THUMB RIGHT-INDEX RIGHT-MIDDLE RIGHT-RING RIGHT-LITTLE))

;;(c-constant FP_VERIFY_NO_MATCH int)
;; (c-constant FP_VERIFY_MATCH int)
;; (c-constant FP_VERIFY_RETRY int)
;; (c-constant FP_ENROLL_RETRY int)
;; (c-constant FP_VERIFY_RETRY_TOO_SHORT int)
;; (c-constant FP_ENROLL_RETRY_TOO_SHORT int)
;; (c-constant FP_VERIFY_RETRY_CENTER_FINGER int)
;; (c-constant FP_ENROLL_RETRY_CENTER_FINGER int)
;; (c-constant FP_VERIFY_RETRY_REMOVE_FINGER int)
;; (c-constant FP_ENROLL_RETRY_REMOVE_FINGER int)

;;; Initialization

(define fp-init
                                        ;(foreign-lambda int fp_init))
  0)

;;; Debugging

(define fp-set-debug
  (foreign-lambda void fp_set_debug int))

;;; Device discovery

;;; TODO: Verificar o retorno aqui.
(define fp-discover-devs
  (foreign-lambda c-pointer fp_discover_devs))

;;; Verification


;; (define fp-verify-finger-img
;;   ; "int fp_verify_finger_img(fp_dev* device, fp_print_data* enrolled_print, fp_img* image"
;;   (foreign-lambda int "fp_verify_finger_img" c-pointer c-pointer (c-pointer "fp_img*")))

;; (define fp-dev-open
;;   (foregin ))

;; (define (verify-finger fingerprint-data)
;;   )


