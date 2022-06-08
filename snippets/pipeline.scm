
(define (reverse lst)
    (define (impl inp out)
        (if (null? inp)
            out
            (impl (cdr inp) (cons (car inp) out))))
    (impl lst '()))

(define (fit steps input)
    (define (impl steps input new-steps)
        (if (null? steps)                        ;; no more steps to process
            (reverse new-steps)                  ;; reverse the order of the list
            (let ((fitted ((car steps) input)))  ;; extract & call the step
                (impl
                    (cdr steps)                  ;; drop first step from the list
                    (fitted input)               ;; use the step to transform input
                    (cons fitted new-steps)))))  ;; prepend the step to list
    (impl steps input '()))                      ;; call the implementation

(define (transform steps input)
    (if (null? steps)                  ;; no more steps to process
        input
        (transform
            (cdr steps)                ;; drop first step from the list
            ((car steps) input))))     ;; use the step to transform input

(transform
    (fit
        (list
            (lambda (x)
                (lambda (y) (+ y x)))  ;; => (lambda (y) (+ y 2))
            (lambda (x)
                (lambda (y) (/ y x)))) ;; => (lambda (y) (/ y 4))
        2)
    7)                                 ;; => (/ (+ 7 2) 4)
