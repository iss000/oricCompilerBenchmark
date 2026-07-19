;
; 32-bit (long) runtime - divide / modulo.
; Split per family so link65 only pulls what a program references
; (file-granular dead code elimination via library.ndx).
; Convention: operand A in op1..op2+1 (4 contiguous zp bytes), operand B
; pointed to by tmp, result in op1:op2. See the L families in MACROS.H.
;
	.text

	.(

+ldiv32u
	ldy #3
copyd32
	lda (tmp),y
	sta lwork,y
	lda #0
	sta lrem,y
	dey
	bpl copyd32
	ldx #32
divloop32
	; shift dividend/quotient left, MSB into remainder
	asl op1
	rol op1+1
	rol op2
	rol op2+1
	rol lrem
	rol lrem+1
	rol lrem+2
	rol lrem+3
	; if remainder >= divisor: remainder -= divisor, quotient |= 1
	sec
	lda lrem
	sbc lwork
	tay			; keep the difference bytes in Y/ldtmp until
	lda lrem+1		; we know whether the subtraction held
	sbc lwork+1
	sta ldtmp
	lda lrem+2
	sbc lwork+2
	sta ldtmp+1
	lda lrem+3
	sbc lwork+3
	bcc divskip32		; remainder < divisor: leave it alone
	sta lrem+3
	lda ldtmp+1
	sta lrem+2
	lda ldtmp
	sta lrem+1
	sty lrem
	inc op1			; low bit of the (just shifted) quotient is 0
divskip32
	dex
	bne divloop32
	rts

+lmod32u
	jsr ldiv32u
	lda lrem
	sta op1
	lda lrem+1
	sta op1+1
	lda lrem+2
	sta op2
	lda lrem+3
	sta op2+1
	rts

; ---- signed divide / modulo (C89: quotient truncates toward zero,
;      remainder takes the sign of the dividend) ------------------------
; B cannot be negated in place (it may be a user variable or constant),
; so the sign pass copies |B| into lscratch and repoints tmp at it.

lsignprep
	; lsign = dividend sign (bit7), lsign+1 = sign of the quotient
	lda op2+1
	sta lsign
	ldy #3
	lda (tmp),y
	eor op2+1
	sta lsign+1
	; A = |A|
	bit lsign
	bpl labspos
	jsr lneg32
labspos
	; B = |B| (copy into lscratch when negative, repoint tmp)
	ldy #3
	lda (tmp),y
	bpl lbabs_done
	; lscratch = 0 - B
	sec
	ldy #0
	lda #0
	sbc (tmp),y
	sta lscratch
	iny
	lda #0
	sbc (tmp),y
	sta lscratch+1
	iny
	lda #0
	sbc (tmp),y
	sta lscratch+2
	iny
	lda #0
	sbc (tmp),y
	sta lscratch+3
	lda #<lscratch
	sta tmp
	lda #>lscratch
	sta tmp+1
lbabs_done
	rts

+ldiv32i
	jsr lsignprep
	jsr ldiv32u
	bit lsign+1
	bpl ldivi_done
	jmp lneg32		; negative quotient
ldivi_done
	rts

+lmod32i
	jsr lsignprep
	jsr lmod32u
	bit lsign		; remainder follows the dividend's sign
	bpl lmodi_done
	jmp lneg32
lmodi_done
	rts

	.)
