;
; 32-bit (long) runtime - shifts.
; Split per family so link65 only pulls what a program references
; (file-granular dead code elimination via library.ndx).
; Convention: operand A in op1..op2+1 (4 contiguous zp bytes), operand B
; pointed to by tmp, result in op1:op2. See the L families in MACROS.H.
;
	.text

	.(

+llsh32
	ldy #0
	lda (tmp),y
	tax
	beq lshdone32
lshloop32
	asl op1
	rol op1+1
	rol op2
	rol op2+1
	dex
	bne lshloop32
lshdone32
	rts

+lrshl32			; logical (unsigned) >>
	ldy #0
	lda (tmp),y
	tax
	beq rshldone32
rshlloop32
	lsr op2+1
	ror op2
	ror op1+1
	ror op1
	dex
	bne rshlloop32
rshldone32
	rts

+lasr32				; arithmetic (signed) >>
	ldy #0
	lda (tmp),y
	tax
	beq asrdone32
asrloop32
	lda op2+1
	cmp #$80		; carry = sign bit
	ror op2+1
	ror op2
	ror op1+1
	ror op1
	dex
	bne asrloop32
asrdone32
	rts

	.)
