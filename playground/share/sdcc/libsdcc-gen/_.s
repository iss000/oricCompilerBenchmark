;)              _
;)  ___ ___ _ _|_|___ ___
;) |  _| .'|_'_| |_ -|_ -|
;) |_| |__,|_,_|_|___|___|
;)         raxiss (c) 2021

; ======================================================================
; Template assembler file
; ----------------------------------------------------------------------

	.optsdcc -mm6502

  ; Ordering of segments for the linker.
	.area HOME    (CODE)
	.area GSINIT0 (CODE)
 	.area GSINIT  (CODE)
 	.area GSFINAL (CODE)
 	.area CSEG    (CODE)
 	.area XINIT   (CODE)
 	.area CONST   (CODE)
 	.area DSEG    (PAG)
 	.area OSEG    (PAG, OVR)
 	.area XSEG
 	.area XISEG
 	.area	CODEIVT (ABS)
