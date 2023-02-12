.setcpu		      "6502"
.autoimport     on
.case		        on
.debuginfo	    off

.importzp       sp

; .importzp       sreg, regsave, regbank
; .importzp       tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4

.export         __STARTUP__ ; required and used internally
.import         _main

; .segment        "ZEROPAGE"
;
; sp:             .res  2
; sreg:           .res  2
; regsave:        .res  2
; regbank:        .res  2
;
; tmp1:        	  .res  1
; tmp2:           .res  1
; tmp3:           .res  1
; tmp4:           .res  1
; ptr1:           .res  2
; ptr2:           .res  2
; ptr3:           .res  2
; ptr4:           .res  2

.segment        "STARTUP"

__STARTUP__:
_start:
	              lda 	#<__stack
	              sta 	sp
	              lda 	#>__stack
	              sta 	sp+1

								jmp		_main
