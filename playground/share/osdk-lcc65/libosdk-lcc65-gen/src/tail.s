
#ifndef OSDK_CUSTOM_STACK

 .text

; TODO: the sentinel should only exist in a debug configuration, but the
; OSDK has no debug/release management yet.
osdk_check
	.asc "Dbug"

osdk_text_end

;
; The stack lives in .bss: 256 bytes of RAM right above the loaded image,
; reserved but NOT emitted (it used to be a .dsb 256 in .text, costing 256
; bytes of file size and load time in every program).
; XA does not automatically place .bss after .text, so the segment origin
; is set explicitly from the end-of-text label.
; It should be protected !
;
; Warning: If you use the malloc functions, the heap is by default defined
; after the stack location (osdk_stack+_stacksize)!
;
 .bss
 *= osdk_text_end

osdk_stack
	.dsb 256

; osdk_end keeps its historical meaning: first free byte after everything
; the program owns, stack included.
osdk_end

#else

 .text

osdk_end
;.byt $FF

#endif OSDK_CUSTOM_STACK
