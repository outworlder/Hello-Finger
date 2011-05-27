(use srfi-1)

(import foreign)

(define *FPRINT-INITIALIZED* #f)

(define (is-open?)
  *DEVICE-OPEN*)

(define (is-initialized?)
  *FPRINT-INITIALIZED*)

(define cfprint-debug-mode (make-parameter #f))

(define (plog str)
  (if (cfprint-debug-mode)
      (print str)))

(foreign-declare "#include <libfprint/fprint.h>")

;; (define-syntax c-constant
;;   (syntax-rules ()
;;     ([_ name type] (define name (foreign-value name type)))))

;; ;;; Constantes
;; ;; (c-constant LEFT_THUMB int)
;; ;; (c-constant LEFT_INDEX int)
;; ;; (c-constant LEFT_MIDDLE int)
;; ;; (c-constant LEFT_RING int)
;; ;; (c-constant LEFT_LITTLE int)
;; ;; (c-constant RIGHT_THUMB int)
;; ;; (c-constant RIGHT_INDEX int)
;; ;; (c-constant RIGHT_MIDDLE int)
;; ;; (c-constant RIGHT_RING int)
;; ;; (c-constant RIGHT_LITTLE int)

;; (define LEFT-HAND
;;   '(LEFT-THUMB LEFT-INDEX LEFT-MIDDLE LEFT-RING LEFT-LITTLE))

;; (define RIGHT-HAND
;;   '(RIGHT-THUMB RIGHT-INDEX RIGHT-MIDDLE RIGHT-RING RIGHT-LITTLE))

;; ;;(c-constant FP_VERIFY_NO_MATCH int)
;; ;; (c-constant FP_VERIFY_MATCH int)
;; ;; (c-constant FP_VERIFY_RETRY int)
;; ;; (c-constant FP_ENROLL_RETRY int)
;; ;; (c-constant FP_VERIFY_RETRY_TOO_SHORT int)
;; ;; (c-constant FP_ENROLL_RETRY_TOO_SHORT int)
;; ;; (c-constant FP_VERIFY_RETRY_CENTER_FINGER int)
;; ;; (c-constant FP_ENROLL_RETRY_CENTER_FINGER int)
;; ;; (c-constant FP_VERIFY_RETRY_REMOVE_FINGER int)
;; ;; (c-constant FP_ENROLL_RETRY_REMOVE_FINGER int)

;; ;;; Initialization

(define fp-init
  (foreign-lambda int fp_init))

(define fp-exit
  (foreign-lambda void fp_exit))

(define (cfp-initialize)
  (if (is-initialized?)
      (begin
        (plog "FPrint já inicializada.")
        #f)
      (let ([result (fp-init)])
        (if (eq? result 0)
            (begin
              (plog "FPrint inicializada com sucesso")
              (set! *FPRINT-INITIALIZED* #t)))
        result)))

(define (cfp-finalize)
  (if (is-initialized?)
      (begin
        (fp-exit)
        (plog "FPrint finalizada.")
        (set! *FPRINT-INITIALIZED* #f)
        #t)
      (begin
        (plog "FPrint já foi encerrada.")
        #f)))

;; ;;; Debugging

;; (define fp-set-debug
;;   (foreign-lambda void fp_set_debug int))

;; ;;; Device discovery

;; ;;; TODO: Verificar o retorno aqui.
;;struct fp_dscv_dev** fp_discover_devs	(	void 		 )
(define fp-discover-devices
  (foreign-lambda (c-pointer (c-pointer (struct "fp_dscv_dev"))) fp_discover_devs))

(define fp-dscv-devs-free
  (foreign-lambda void fp_dscv_devs_free (c-pointer (c-pointer (struct "fp_dscv_dev")))))

;;; Driver operations
; const char* fp_driver_get_name	(	struct fp_driver * 	drv	 ) 	

(define cfp-get-number-of-devices
  (foreign-lambda* int (((c-pointer (c-pointer (struct "fp_dscv_dev"))) device_list))
                   "int i = 0;
                    if (!device_list) {
                       C_return(0);
                    } else {
                      while (*(device_list++)) { i++; }
                      C_return(i);
                    }"))

;;struct fp_driver* fp_dscv_dev_get_driver	(	struct fp_dscv_dev * 	dev	 )
(define fp-dscv-dev-get-driver
  (foreign-lambda (c-pointer (struct "fp_driver")) fp_dscv_dev_get_driver (c-pointer (struct "fp_dscv_dev"))))


(define fp-driver-get-name
  (foreign-lambda c-string fp_driver_get_name c-pointer))

;;; High-level API

(define-record device ptr driver)
(define-record driver ptr type name)

(define cfp-get-next-device
  (foreign-lambda* (c-pointer (c-pointer (struct "fp_dscv_dev"))) (((c-pointer (c-pointer (struct "fp_dscv_dev"))) device_list))
                   "if (!*device_list) {
                      C_return(0);
                    } else {
                      C_return(++device_list);
                    }"))

(define cfp-dereference
  (foreign-lambda* (c-pointer (struct "fp_dscv_dev")) (((c-pointer (c-pointer (struct "fp_dscv_dev"))) device_list))
                   "C_return(*device_list);"
                   ))

;;; Discover, creates records and issues further calls to obtain the device and driver capabilities
(define (discover-devices)
  (unless (is-initialized?)
    (cfp-initialize))
  (let ([device-pointers (fp-discover-devices)])
    (let ([device-list
           (unfold
            (lambda (x) (equal? x #f))
            (lambda (x) (make-device (cfp-dereference x) #f))
            (lambda (x) (cfp-get-next-device x))
            device-pointers)])
      (fp-dscv-devs-free device-pointers)
      device-list)))

;; ;;; Verification


;; ;; (define fp-verify-finger-img
;; ;;   ; "int fp_verify_finger_img(fp_dev* device, fp_print_data* enrolled_print, fp_img* image"
;; ;;   (foreign-lambda int "fp_verify_finger_img" c-pointer c-pointer (c-pointer "fp_img*")))

;; ;; (define fp-dev-open
;; ;;   (foregin ))

;; ;; (define (verify-finger fingerprint-data)
;; ;;   )


