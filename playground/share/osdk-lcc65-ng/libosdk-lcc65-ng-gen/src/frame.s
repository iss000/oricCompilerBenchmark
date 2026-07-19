;
; C stack-frame helpers (enter/leave).
;
; These used to live in header.s, which link65 always includes in full,
; so every program paid their ~140 bytes. At -O2 and above the compiler
; omits the frame for functions with no parameters, no locals and no
; register variables (omit_frame in gen.c), so a program whose functions
; are all frameless never references enter/leave - moving them to an
; on-demand library file lets such programs drop them entirely.
;
	.text

; Code is called this way:
;
;	ldx #6    <- Number of bytes of local variables
;	lda #1    <- Number of registers to save (registers being adresses from 'reg0' to 'reg7')
;	jsr enter
;
; Y=The routine that calls a subfunction puts in Y the number of parameters*2. Example is CALLV_C(_drawbox,6)
enter
	sty tmp		; Save the number of bytes reserved for parameters
	stx tmp+1

	; Save the registers
	asl			; Number of registers to save x2
	sta op2		; =number of bytes to save
	tax
	beq noregstosave
savereg
	lda reg0-1,x
	sta (sp),y
	iny
	dex
	bne savereg

noregstosave
	sty op2+1	; New stack offset after the registers have been saved

	; Save the argument pointer
	lda ap
	sta (sp),y
	iny
	lda ap+1
	sta (sp),y
	iny

	; Save the frame pointer
	lda fp
	sta (sp),y
	iny
	lda fp+1
	sta (sp),y
	iny

	; Save the number of bytes saved for the registers
	lda op2
	sta (sp),y
	iny
	lda tmp		; Previously saved number of bytes for parameters
	sta (sp),y

	; Update the argument pointer
	; AP=SP
	; FP=SP+stack offset
	clc
	lda sp
	sta ap
	adc op2+1
	sta fp
	lda sp+1
	sta ap+1
	adc #0
	sta fp+1

	; SP=FP+X
	lda tmp+1
	adc fp
	sta sp
	lda fp+1
	adc #0
	sta sp+1
	rts


leave
	stx op2			; Save X
	sta op2+1		; Save A

	; Restore sp from ap
	lda ap
	sta sp
	lda ap+1
	sta sp+1

	ldy #4
	lda (fp),y
	tax
	iny
	lda (fp),y
	tay
	txa
	beq noregstorestore

restorereg
	lda (sp),y
	sta reg0-1,x
	iny
	dex
	bne restorereg

noregstorestore
	; Restore AP
	ldy #0
	lda (fp),y
	sta ap
	iny
	lda (fp),y
	sta ap+1

	; Restore FP
	iny
	lda (fp),y
	sta tmp+0
	tax
	iny
	lda (fp),y
	sta fp+1
	stx fp

	ldx op2			; Restore X
	lda op2+1		; Restore A
	rts
