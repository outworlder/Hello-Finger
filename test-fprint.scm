(use test)
(use data-structures)
(use ports)
(use extras)

(use lolevel)
(use sequences)

(include "fprint.scm")

(cfprint-debug-mode #f)

(test-group "Low-level"
            (test-group "Inicialização"
                        (test "Deve inicializar a libfprint com sucesso" 0 (cfp-initialize))
                        (test "Deve finalizar a libfprint com sucesso" #t (cfp-finalize)))
            (cfp-initialize)
            (test-group "Device Discovery"
                        (let ([result (fp-discover-devices)])
                          (test "Deve conseguir obter um ponteiro para a lista de dispositivos" #t (pointer? result))
                          (fp-dscv-devs-free result))
                        (test "Deve retornar 0 dispositivos se for passado um ponteiro nulo" 0 (cfp-get-number-of-devices #f))
                        (let ([result (fp-discover-devices)])
                          (test "Deve conseguir contar os dispositivos" 1 (cfp-get-number-of-devices result))
                          (fp-dscv-devs-free result))
                        (let ([device (cfp-dereference (fp-discover-devices))])
                          (test "Deve desreferenciar ponteiro para um dispositivo" #t (pointer? device)))
                        )
            (test-group "Drivers"
                        (let ([device (cfp-dereference (fp-discover-devices))])
                          (test "Deve obter o driver" #t (pointer? (fp-dscv-dev-get-driver device))))
                        (let ([device (fp-dscv-dev-get-driver (cfp-dereference (fp-discover-devices)))])
                          (test "Deve obter o nome do driver" "uru4000" (fp-driver-get-name device)))
                        ))

(test-group "High-level"
            (test-group "Device Discovery"
                        (test "Deve obter uma lista de dispositivos" #t (list? (discover-devices)))
                        (test "A lista de dispositivos deve conter somente records do tipo \"device\""
                              #t (all? (lambda (x)
                                         (device? x))
                                       (discover-devices)))))

(cfp-finalize)
