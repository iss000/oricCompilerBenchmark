


	.zero

#ifndef OSDK_ZP_START
#define OSDK_ZP_START $50
#endif
	*= OSDK_ZP_START

zp_compiler_save_start
#include "zp_crt.inc"
zp_compiler_save_end


	.text

osdk_start
    ;jmp osdk_start		; Comment out to not autostart the system

	;#include "adress.tmp"
	;*=$800

	;
	; Needs to clear the BSS section
	;




	; Debugger module id: stamp _osdk_dbg_module as the very first thing a module
	; runs (C or asm), so the VS Code debugger auto-switches to the matching overlay.
	; Transparent: only compiled when the build defines OSDK_MODULE_ID (per-overlay
	; -DOSDK_MODULE_ID=<id>); other OSDK programs never define it, so it's a no-op —
	; and the OSDK-namespaced name avoids clashing with a project's own 'MODULE'.
#ifdef OSDK_MODULE_ID
	lda #OSDK_MODULE_ID
	sta _osdk_dbg_module
#endif

	tsx
	lda #<osdk_stack
	sta sp
	lda #>osdk_stack
	sta sp+1
	ldy #0
	stx retstack
	jmp _main
retstack	
	.byt 0

; enter/leave (the C stack-frame helpers) live in lib/frame.s so that
; programs whose functions are all frameless (-O2+ omit_frame) don't pay
; their bytes.

jsrvect 
	jmp (0000)

_exit
	ldx retstack
	txs
	rts

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


#define load_acc1	$DE7B
#define load_acc2	$DD51
#define store_acc	$DEAD
#define fadd		$DB25
#define fsub		$DB0E
#define fmul		$DCF0
#define fdiv		$DDE7
#define fneg		$E271
#define fcomp		$DF4C
#define givayf		$DF40	; UNSIGNED 16bit A(high)/Y(low) to FPA (forces the sign
							; byte positive). The historical cif value $DF24 was
							; wrong: that is SGN's tail, converting only the signed
							; 8bit value in A.

; The int<->float conversion routines (cif/cfi) live in lib/float.s so
; that only programs using floating point pay their bytes.

