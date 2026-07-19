;
; int atoi(const char *s)
;
; C89 semantics: skip leading whitespace, accept an optional +/- sign,
; accumulate decimal digits until the first non-digit; no digits gives 0.
; Overflow behavior is undefined (16 bit wrap here).
;
; Uses op1 as the accumulator and op2 as scratch for the multiply by ten.
;
_atoi
	ldy #0
	lda (sp),y
	sta tmp
	iny
	lda (sp),y
	sta tmp+1
	lda #0
	sta op1
	sta op1+1
	sta atoisign
	ldy #0

atoispace
	lda (tmp),y
	cmp #$20		; space
	beq atoiskip
	cmp #9			; \t..\r are whitespace
	bcc atoisigns
	cmp #14
	bcs atoisigns
atoiskip
	iny
	bne atoispace		; strings limited to 256 bytes, like printf

atoisigns
	cmp #$2D		; minus
	bne atoiplus
	sta atoisign		; any nonzero value
	iny
	jmp atoidigit
atoiplus
	cmp #$2B		; plus
	bne atoifirst		; current char is already loaded
	iny

atoidigit
	lda (tmp),y
atoifirst
	cmp #$30		; digit 0
	bcc atoiend
	cmp #$3A		; digit 9 + 1
	bcs atoiend
	sec
	sbc #$30
	pha
	; op1 = op1 * 10   (10x = 8x + 2x)
	asl op1
	rol op1+1		; 2x
	lda op1
	sta op2
	lda op1+1
	sta op2+1
	asl op1
	rol op1+1
	asl op1
	rol op1+1		; 8x
	clc
	lda op1
	adc op2
	sta op1
	lda op1+1
	adc op2+1
	sta op1+1
	; op1 += digit
	pla
	clc
	adc op1
	sta op1
	lda op1+1
	adc #0
	sta op1+1
	iny
	jmp atoidigit

atoiend
	lda atoisign
	beq atoipositive
	sec
	lda #0
	sbc op1
	tax
	lda #0
	sbc op1+1
	rts
atoipositive
	ldx op1
	lda op1+1
	rts

atoisign
	.byt 0
