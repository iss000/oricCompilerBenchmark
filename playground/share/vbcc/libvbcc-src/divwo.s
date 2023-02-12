	zpage r0
	zpage r1
	zpage r2
	zpage r3
	zpage r4
	zpage r5
	global ___divuint16wo
	global ___divint16wo
	global ___moduint16wo
	global ___modint16wo

divisor = r2     ;$59 used for hi-byte
dividend = r0	  ;$fc used for hi-byte
remainder = r4	  ;$fe used for hi-byte
result = dividend ;save memory by reusing divident to store the result

	section text

___modint16wo:
	ldy #0
	lda r1
	bpl mpos
	lda #0
	sec
	sbc r0
	sta r0
	lda #0
	sbc r1
	sta r1
	ldy #1
mpos:
	lda r3
	bpl mpos2
	lda #0
	sec
	sbc r2
	sta r2
	lda #0
	sbc r3
	sta r3
mpos2:
	cpy #0
	beq ___moduint16wo
	jsr ___moduint16wo
;	cpy #0
;	beq mnoneg
	eor #255
	clc
	adc #1
	pha
	txa
	eor #255
	adc #0
	tax
	pla
mnoneg:
	rts

___moduint16wo:
	jsr ___divuint16wo
	lda remainder
	ldx remainder+1
	rts

___divint16wo:
	lda r1
	bpl posjx
	lda #0
	sec
	sbc r0
	sta r0
	lda #0
	sbc r1
	sta r1
	lda r3
	bpl negres
	lda #0
	sec
	sbc r2
	sta r2
	lda #0
	sbc r3
	sta r3
	jmp ___divuint16wo
negres:
	jsr ___divuint16wo
	eor #255
	clc
	adc #1
	pha
	txa
	eor #255
	adc #0
	tax
	pla
	rts

posjx:
	lda r3
	bpl ___divuint16wo

	lda #0
	sec
	sbc r2
	sta r2
	lda #0
	sbc r3
	sta r3
	jmp negres



___divuint16wo:
divide	lda #0	        ;preset remainder to 0
	sta remainder
	sta remainder+1
	ldx #16	        ;repeat for each bit: ...

divloop	asl dividend	;dividend lb & hb*2, msb -> Carry
	rol dividend+1
	rol remainder	;remainder lb & hb * 2 + msb from carry
	rol remainder+1
	lda remainder
	sec
	sbc divisor	;substract divisor to see if it fits in
	tay	        ;lb result -> Y, for we may need it later
	lda remainder+1
	sbc divisor+1
	bcc skip	;if carry=0 then divisor didn't fit in yet

	sta remainder+1	;else save substraction result as new remainder,
	sty remainder
	inc result	;and INCrement result cause divisor fit in 1 times

skip	dex
	bne divloop

	lda result
	ldx result+1

	rts
