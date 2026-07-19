;
; 32-bit (long) runtime - add / subtract.
; Split per family so link65 only pulls what a program references
; (file-granular dead code elimination via library.ndx).
; Convention: operand A in op1..op2+1 (4 contiguous zp bytes), operand B
; pointed to by tmp, result in op1:op2. See the L families in MACROS.H.
;
	.text

	.(

+ladd32
	ldy #0
	clc
	lda op1
	adc (tmp),y
	sta op1
	iny
	lda op1+1
	adc (tmp),y
	sta op1+1
	iny
	lda op2
	adc (tmp),y
	sta op2
	iny
	lda op2+1
	adc (tmp),y
	sta op2+1
	rts

+lsub32
	ldy #0
	sec
	lda op1
	sbc (tmp),y
	sta op1
	iny
	lda op1+1
	sbc (tmp),y
	sta op1+1
	iny
	lda op2
	sbc (tmp),y
	sta op2
	iny
	lda op2+1
	sbc (tmp),y
	sta op2+1
	rts

	.)
