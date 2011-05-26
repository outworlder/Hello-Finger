(use iup)
(use iup-web)


(define IUP_IGNORE    -1)
(define IUP_DEFAULT   -2)
(define IUP_CLOSE     -3)
(define IUP_CONTINUE  -4)

(define *urls*
  '((redmine "http://172.25.136.97/redmine")))

(define browser
  (web-browser))

(define btn-ok
  (button title: "OK"
          action: (lambda (args)
                    (print "OK pressed!"))))

(define btn-status
  (button title: "Status"
          action: (lambda (args)
                    (print "Browser status: " (attribute browser 'status)))))

(define btn-exit
  (button title: "Exit"
          action: (lambda (args)
                    (exit))))

(define textbox-url
  (textbox expand: "HORIZONTAL"))

(define btn-go
  (button title: "GO!"
          action: (lambda (args)
                    (let ([url (attribute textbox-url 'value)])
                      (print "URL:" url)
                      (set! (attribute browser 'value) url)
                      (set! (attribute browser 'reload) #t)
                      (print "Browser status:" (attribute browser 'status))))))

(define main-window
  (dialog title: "Redmine" size: "800x600"
          (vbox
           ;; (hbox 
           ;;  (label title: "URL:")
           ;;  textbox-url
           ;;  btn-go)
           browser
           (hbox (fill) btn-ok btn-status btn-exit))))

(show main-window)

;;; Authentication dialog

(define (login-dialog)
  (let* ([tb-username (textbox)]
        [tb-password (textbox)]
        [btn-login-ok (button title: "OK"
                              action: (lambda (args)
                                        (print "Login ok")
                                        (let ([login (attribute tb-username 'value)]
                                              [pass (attribute tb-password 'value)])
                                          (if (and (equal? login "admin") (equal? pass "admin"))
                                              IUP_CLOSE
                                              IUP_CONTINUE))))]
        [btn-login-cancel (button title: "Cancel"
                                  action: (lambda (args)
                                            (exit)))])
    (let* ([dlg 
           (dialog title: "Login"
                   (vbox
                    (label title: "Entre com as informações de login")
                    (hbox
                     (label title: "Login:")
                     (fill)
                     tb-username)
                    (hbox
                     (label title: "Senha:")
                     (fill)
                     tb-password)
                    (hbox
                     (fill)
                     btn-login-ok
                     btn-login-cancel)))]
           [result (show dlg modal?: #t)])
      (hide dlg)
      result)))

(print "Authenticating user.")
(print "Result:" (login-dialog))
(print "Authenticated.")

(set! (attribute browser 'value) (cadr  (assoc 'redmine *urls*)))

(main-loop)
