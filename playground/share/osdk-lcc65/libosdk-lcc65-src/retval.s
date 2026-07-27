;
; Common return-value tails, jumped to by the hand-written library
; routines (string compares, malloc, ...).
;

	.text

reterr
	lda #$ff	; return -1
	tax
	rts

retzero
false
	lda #0		;return 0
	tax
	rts

true
	ldx #1		;return 1
	lda #0
	rts
