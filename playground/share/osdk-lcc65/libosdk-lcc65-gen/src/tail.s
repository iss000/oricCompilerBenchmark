
#ifndef OSDK_CUSTOM_STACK

 .text

;
; This area is used as a stack.
; it should be protected !
;
osdk_stack
	.dsb 256
; Warning: If you use the malloc functions, the heap is by default defined after the stack location!
osdk_check
	.asc "Dbug"

#endif OSDK_CUSTOM_STACK

osdk_end 
;.byt $FF

