	zpage r0
	zpage r1
	zpage r2
	zpage r3
	zpage r4
	zpage r5
	global ___divint16

	section text

___divint16:
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
	jmp ___divuint16
negres:
	jsr ___divuint16
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
	bpl ___divuint16

	lda #0
	sec
	sbc r2
	sta r2
	lda #0
	sbc r3
	sta r3
	jmp negres


