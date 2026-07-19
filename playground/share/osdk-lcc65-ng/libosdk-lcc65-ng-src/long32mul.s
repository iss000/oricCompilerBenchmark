;
; 32-bit (long) runtime - multiply.
; Split per family so link65 only pulls what a program references
; (file-granular dead code elimination via library.ndx).
; Convention: operand A in op1..op2+1 (4 contiguous zp bytes), operand B
; pointed to by tmp, result in op1:op2. See the L families in MACROS.H.
;
	.text

	.(

+lmul32
	; lwork = B (the shifting addend), lrem = product accumulator
	ldy #3
copyb32
	lda (tmp),y
	sta lwork,y
	lda #0
	sta lrem,y
	dey
	bpl copyb32
	ldx #32
mulloop32
	; shift A right, LSB into carry
	lsr op2+1
	ror op2
	ror op1+1
	ror op1
	bcc mulskip32
	; product += lwork
	clc
	lda lrem
	adc lwork
	sta lrem
	lda lrem+1
	adc lwork+1
	sta lrem+1
	lda lrem+2
	adc lwork+2
	sta lrem+2
	lda lrem+3
	adc lwork+3
	sta lrem+3
mulskip32
	; lwork <<= 1
	asl lwork
	rol lwork+1
	rol lwork+2
	rol lwork+3
	dex
	bne mulloop32
	; result -> op1:op2
	lda lrem
	sta op1
	lda lrem+1
	sta op1+1
	lda lrem+2
	sta op2
	lda lrem+3
	sta op2+1
	rts

	.)
