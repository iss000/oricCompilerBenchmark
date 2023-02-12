	zpage	btmp0
	zpage	btmp1
	zpage	btmp2
	zpage	r30
	zpage	r31

	section	text
lparms:
	lda	btmp0+3
	sta	r30
	bpl	a1done
	ldx	#0
	jsr	neg
a1done:
	lda	btmp1+3
	sta	r31
	bpl	a2done
	ldx	#4
	jsr	neg
a2done:
	rts

neg:
	sec
	lda	#0
	tay
	sbc	btmp0,x
	sta	btmp0,x
	inx
	tya
	sbc	btmp0,x
	sta	btmp0,x
	inx
	tya
	sbc	btmp0,x
	sta	btmp0,x
	inx
	tya
	sbc	btmp0,x
	sta	btmp0,x
	rts

	global	___divint32wo
___divint32wo:
	jsr	lparms
	jsr	___intdiv32
	lda	r30
	eor	r31
	bpl	divdone
	ldx	#0
	jsr	neg
divdone:
	rts

	global	___modint32wo
___modint32wo:
	jsr	lparms
	jsr	___intdiv32
	lda	r30
	bpl	moddone
	ldx	#8
	jsr	neg
moddone:
	jmp	___modcopy


