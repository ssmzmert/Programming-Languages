(define (twoOperatorCalculator exp)
  (cond ((null? exp) 0)                 
        ((null? (cdr exp)) (car exp))   
        (else                           
          (let ((operand (car  exp))
                (operator (cadr exp))
                (operands (cddr exp)))
            ((case operator             
               ((+) +)
               ((-) -))
             operand
             (twoOperatorCalculator operands))))))



(define (fourOperatorCalculator exp)
  (cond ((null? exp) 0)                 
        ((null? (cdr exp)) (car exp))   
        (else                           
          (let ((operand (car  exp))
                (operator (cadr exp))
                (operands (cddr exp)))
            ((case operator             
               ((*) *)
               ((/) /))
             operand
             (fourOperatorCalculator operands))))))


(define (calculator exp)
  (cond ((null? exp) 0)                 
        ((null? (cdr exp)) (car exp))   
        (else                           
          (let ((operand (car  exp))
                (operator (cadr exp))
                (operands (cddr exp)))
            ((case operator             
               ((*) *)
               ((/) /)
	       ((+) +)
	       ((-) -))
             operand
             (calculator operands))))))
