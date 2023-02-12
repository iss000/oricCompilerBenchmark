	zpage	btmp0
	zpage	btmp1
	zpage	btmp2

; Do (ptr1:sreg) / (ptr3:ptr4) --> (ptr1:sreg), remainder in (ptr2:tmp3:tmp4)
; This is also the entry point for the signed division

	section	text
	global	___modcopy
	global	___moduint32wo
___moduint32wo:
	jsr	___divuint32wo
___modcopy:
	lda	btmp2
	sta	btmp0
	lda	btmp2+1
	sta	btmp0+1
	lda	btmp2+2
	sta	btmp0+2
	lda	btmp2+3
	sta	btmp0+3
	rts


	global	___intdiv32
	global	___divuint32wo
___divuint32wo:

___intdiv32:
	lda     #0
        sta     btmp2+1
        sta     btmp2+2
        sta     btmp2+3
        ldy     #32
loop2:
        asl     btmp0
        rol     btmp0+1
        rol     btmp0+2
        rol     btmp0+3
        rol
        rol     btmp2+1
        rol     btmp2+2
        rol     btmp2+3

        tax
        cmp     btmp1
        lda     btmp2+1
        sbc     btmp1+1
        lda     btmp2+2
        sbc     btmp1+2
        lda     btmp2+3
        sbc     btmp1+3
        bcc     skip

        sta     btmp2+3
        txa
        sbc     btmp1
        tax
        lda     btmp2+1
        sbc     btmp1+1
        sta     btmp2+1
        lda     btmp2+2
        sbc     btmp1+2
        sta     btmp2+2
        inc     btmp0

skip:
        txa
        dey
        bne     loop2
        sta     btmp2
        rts


