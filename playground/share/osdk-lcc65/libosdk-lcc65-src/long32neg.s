;
; 32-bit (long) runtime - negate.
; Split per family so link65 only pulls what a program references
; (file-granular dead code elimination via library.ndx).
; Convention: operand A in op1..op2+1 (4 contiguous zp bytes), operand B
; pointed to by tmp, result in op1:op2. See the L families in MACROS.H.
;
	.text

	.(

+lneg32
	sec
	lda #0
	sbc op1
	sta op1
	lda #0
	sbc op1+1
	sta op1+1
	lda #0
	sbc op2
	sta op2
	lda #0
	sbc op2+1
	sta op2+1
	rts

	.)
