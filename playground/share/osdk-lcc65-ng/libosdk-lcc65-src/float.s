;
; Floating point support routines.
;
; The float operations themselves are ROM calls (see the defines in
; header.s: fadd/fsub/fmul/fdiv/fneg/fcomp/givayf); only the two
; int<->float conversions need actual code. They live here, pulled in
; on demand by the linker, so programs without floating point don't
; pay for them.
;

; float -> int (truncation), result in X (low) / A (high)
cfi
	jsr $DF8C
	ldx $D3
	lda $D4
	rts

; signed 16bit int in A (high) / Y (low) -> FPA
cif
	tax					; sets N from the high byte
	bpl cif_positive
	tya					; negative: negate the value, convert the
	eor #$FF			; positive magnitude, then negate the float
	clc
	adc #1
	tay
	txa
	eor #$FF
	adc #0				; carry from the low byte increment propagates
	jsr givayf
	jmp fneg
cif_positive
	txa
	jmp givayf
