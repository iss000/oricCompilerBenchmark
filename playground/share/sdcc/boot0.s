;               _
;   ___ ___ _ _|_|___ ___
;  |  _| .'|_'_| |_ -|_ -|
;  |_| |__,|_,_|_|___|___|
;          raxiss (c) 2022

; =====================================================================
; Boot0 for SDCC-m6502
; =====================================================================
; ---------------------------------------------------------------------
; Ordering of segments for the linker.
;
;   .area HOME    (CODE)
;   .area GSINIT0 (CODE)
;   .area GSINIT  (CODE)
;   .area GSFINAL (CODE)
;   .area CSEG    (CODE)
;   .area XINIT   (CODE)
;   .area CONST   (CODE)
;   .area DSEG    (PAG)
;   .area OSEG    (PAG, OVR)
;   .area XSEG
;   .area XISEG
;   .area CODEIVT (ABS)


; =====================================================================
                .module   boot0
                .optsdcc  -mm6502

; ---------------------------------------------------------------------
                .area   HOME    (CODE)
                .area   STARTUP
                .area   GSINIT0 (CODE)
                .area   GSINIT  (CODE)
                .area   GSFINAL (CODE)
                .area   CODE
                .area   CSEG    (CODE)
                .area   XINIT   (CODE)
                .area   CONST   (CODE)
                .area   DSEG    (PAG)
                .area   OSEG    (PAG, OVR)
                .area   XSEG
                .area   XISEG

; =====================================================================
                .area   ZEROPAGE
; ---------------------------------------------------------------------
                .globl  __TEMP
                .globl  __BASEPTR
; ---------------------------------------------------------------------
__TEMP:         .ds     8
__BASEPTR:      .ds     2

; =====================================================================
;               .area   CODEIVT (ABS)
; ---------------------------------------------------------------------
;               .org    0xfffa
;               .dw     __sdcc_gs_init_startup
;               .dw     __sdcc_gs_init_startup
;               .dw     __sdcc_gs_init_startup

; =====================================================================
                .area   STARTUP
; ---------------------------------------------------------------------
__STARTUP__:
_start:
; ---------------------------------------------------------------------
;                 .globl  __sdcc_gs_init_startup
;                 .globl  __sdcc_external_startup
;                 .globl  ___memcpy
;                 .globl  _memset

; =====================================================================
                .area   GSINIT0
; ---------------------------------------------------------------------
__sdcc_gs_init_startup:
; ---------------------------------------------------------------------
                lda     #<__stack
                sta     __BASEPTR
                lda     #>__stack
                sta     __BASEPTR+1

; ; ---------------------------------------------------------------------
;
;                 jsr     __sdcc_external_startup
;                 beq     __sdcc_init_data
;                 jmp     __sdcc_program_startup
; ; ---------------------------------------------------------------------
__sdcc_init_data:
; ; ---------------------------------------------------------------------
; ; _m6502_genXINIT() start
; ; ---------------------------------------------------------------------
;                 lda     #<s_XINIT
;                 sta     ___memcpy_PARM_2
;                 lda     #>s_XINIT
;                 sta     ___memcpy_PARM_2+1
;                 lda     #<l_XINIT
;                 sta     ___memcpy_PARM_3
;                 lda     #>l_XINIT
;                 sta     ___memcpy_PARM_3+1
;                 lda     #<s_XISEG
;                 ldx     #>s_XISEG
;                 jsr     ___memcpy
; ; ---------------------------------------------------------------------
; ; _m6502_genXINIT() end
; ; ---------------------------------------------------------------------
; ; _m6502_genXSEG() start
; ; ---------------------------------------------------------------------
;                 lda     #0x00
;                 sta     _memset_PARM_2
;                 sta     _memset_PARM_2+1
;                 lda     #<l_XSEG
;                 sta     _memset_PARM_3
;                 lda     #>l_XSEG
;                 sta     _memset_PARM_3+1
;                 lda     #<s_XSEG
;                 ldx     #>s_XSEG
;                 jsr     _memset
; ; ---------------------------------------------------------------------
; ; _m6502_genXSEG() end
; ; ---------------------------------------------------------------------
;
; =====================================================================
                .area   GSFINAL
; ---------------------------------------------------------------------
                jmp     __sdcc_program_startup
; ---------------------------------------------------------------------

; =====================================================================
                .area   CODE
; ---------------------------------------------------------------------
__sdcc_program_startup:
; ---------------------------------------------------------------------
                jmp     _main

; =====================================================================
                .area   BSS
; ---------------------------------------------------------------------



;                 .globl s_XINIT
;                 .globl l_XINIT
;
;                 .globl s_XISEG
;                 .globl s_XSEG
;                 .globl l_XSEG
;
; s_XINIT:        .ds   2
; l_XINIT:        .ds   2
;
; s_XISEG:        .ds   2
;
; s_XSEG:         .ds   2
; l_XSEG:         .ds   2
