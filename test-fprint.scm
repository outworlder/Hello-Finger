(use test)
(use data-structures)
(use ports)
(use extras)

(use lolevel)
(use sequences)

(include "fprint.scm")

(test-group "Low-level"
            (test-group "Inicialização"
                        (test "Deve inicializar a libfprint com sucesso" 0 (fp-init))
                        (test "Deve finalizar a libfprint com sucesso" #t (fp-exit)))

            (test-group "Device Discovery"
                        (let ([result (fp-discover-devices)])
                          (test "Deve conseguir obter um ponteiro para a lista de dispositivos" #t (pointer? result))
                          (fp-dscv-devs-free result))
                        (test "Deve retornar 0 dispositivos se for passado um ponteiro nulo" 0 (cfp-get-number-of-devices #f))
                        (let ([result (fp-discover-devices)])
                          (test "Deve conseguir contar os dispositivos" 1 (cfp-get-number-of-devices result))
                          (fp-dscv-devs-free result))
                        ))

(test-group "High-level"
            (test-group "Device Discovery"
                        (test "Deve obter uma lista de dispositivos" #t (list? (discover-devices)))
                        (test "A lista de dispositivos deve conter somente records do tipo \"device\""
                              #t (all? (lambda (x)
                                         (device? x))
                                       (discover-devices)))))
