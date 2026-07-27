;
; 32-bit (long) runtime - compares.
; Split per family so link65 only pulls what a program references
; (file-granular dead code elimination via library.ndx).
; Convention: operand A in op1..op2+1 (4 contiguous zp bytes), operand B
; pointed to by tmp, result in op1:op2. See the L families in MACROS.H.
;
	.text

	.(

+lcmp32u
	ldy #3
	lda op2+1
	cmp (tmp),y
	bne lcmpdone
	dey
	lda op2
	cmp (tmp),y
	bne lcmpdone
	dey
	lda op1+1
	cmp (tmp),y
	bne lcmpdone
	dey
	lda op1
	cmp (tmp),y
lcmpdone
	rts

; lcmp32i: signed A vs B, same C/Z semantics (C=1 <=> A>=B signed).
; Signed compare == unsigned compare with both sign bits flipped.

+lcmp32i
	ldy #3
	lda (tmp),y
	eor #$80
	sta lsign
	lda op2+1
	eor #$80
	cmp lsign
	bne lcmpdone
	dey
	lda op2
	cmp (tmp),y
	bne lcmpdone
	dey
	lda op1+1
	cmp (tmp),y
	bne lcmpdone
	dey
	lda op1
	cmp (tmp),y
	rts

	.)
