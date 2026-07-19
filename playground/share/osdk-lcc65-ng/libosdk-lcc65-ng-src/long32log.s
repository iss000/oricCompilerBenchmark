;
; 32-bit (long) runtime - bitwise and/or/xor/complement.
; Split per family so link65 only pulls what a program references
; (file-granular dead code elimination via library.ndx).
; Convention: operand A in op1..op2+1 (4 contiguous zp bytes), operand B
; pointed to by tmp, result in op1:op2. See the L families in MACROS.H.
;
	.text

	.(

+land32
	ldy #0
	lda op1
	and (tmp),y
	sta op1
	iny
	lda op1+1
	and (tmp),y
	sta op1+1
	iny
	lda op2
	and (tmp),y
	sta op2
	iny
	lda op2+1
	and (tmp),y
	sta op2+1
	rts

+lor32
	ldy #0
	lda op1
	ora (tmp),y
	sta op1
	iny
	lda op1+1
	ora (tmp),y
	sta op1+1
	iny
	lda op2
	ora (tmp),y
	sta op2
	iny
	lda op2+1
	ora (tmp),y
	sta op2+1
	rts

+lxor32
	ldy #0
	lda op1
	eor (tmp),y
	sta op1
	iny
	lda op1+1
	eor (tmp),y
	sta op1+1
	iny
	lda op2
	eor (tmp),y
	sta op2
	iny
	lda op2+1
	eor (tmp),y
	sta op2+1
	rts

; ---- unary (operate on op1:op2 in place, no B operand) ----------------

+lcom32
	lda op1
	eor #$ff
	sta op1
	lda op1+1
	eor #$ff
	sta op1+1
	lda op2
	eor #$ff
	sta op2
	lda op2+1
	eor #$ff
	sta op2+1
	rts

	.)
