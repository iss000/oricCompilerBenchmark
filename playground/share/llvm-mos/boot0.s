; Implement _start using the _init and _fini system for dynamically building
; initializers and finalizers.

.text

.global _start
.global __do_init_stack
.global __do_zero_bss

; _start is equivalent to _init; both are the start of the init sections.
.section .init_first ,"axR",@progbits
_start:
; sei

; Initialze soft stack pointer from __stack symbol.
.section .init.10,"axR",@progbits
__do_init_stack:
  lda #mos16lo(__stack)
  sta mos8(__rc0)
  lda #mos16hi(__stack)
  sta mos8(__rc1)

; .section .init.20,"axR",@progbits
; __do_zero_bss:
;   jsr __zero_bss

; Targets must provide .init_last to call main and decide what should happen
; afterwards. A target could "jmp exit" to use the normal exit machinery.
; Alternatively "jmp __exit_return" exits by rts from _start without bringing in
; non-local jump mechanisms from _exit.

; _fini is taken to be a finalization function that can be called at any point.
.section .fini_last,"axR",@progbits
  rts

.section .init_last,"axR",@progbits
  jsr main
  jmp __exit_return ; Return to OS
