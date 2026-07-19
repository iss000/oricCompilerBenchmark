;
; 32-bit (long) runtime - shared workspace, plain .dsb in .text (NOT
; .bss: XA interleaves .bss symbol addresses into the surrounding code).
; Pulled automatically by any long32 file that references it.
;
	.text

+lscratch	.dsb 4	; constant/indirect operand staging (LPTB_C etc.)
+lwork		.dsb 4	; operand B copy (mul/div shift space)
+lrem		.dsb 4	; multiply accumulator / division remainder
+lsign		.dsb 2	; sign bookkeeping (signed div/mod, signed compare)
+ldtmp		.dsb 2	; division inner-loop scratch (must not reuse lsign)
