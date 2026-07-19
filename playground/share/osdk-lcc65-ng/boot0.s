;               _
;   ___ ___ _ _|_|___ ___
;  |  _| .'|_'_| |_ -|_ -|
;  |_| |__,|_,_|_|___|___|
;          raxiss (c) 2022

; =====================================================================
; Boot0 for OSDK-lcc65
; =====================================================================

#ifndef __stack
#define __stack $8000
#endif

.zero

#ifndef OSDK_ZP_START
#define OSDK_ZP_START $50
#endif
              *=    OSDK_ZP_START

zp_compiler_save_start
; #include "zp_crt.inc"

;
; CRT zero page variables (44 bytes)
;
; Most of the documentation/comments are from
; 'Another Approach to Instruction Set Architecture - VAX'
;
ap            .dsb  2                   ; Argument pointer - points to the base of the list of arguments or parameters in memory that are passed to the procedure @ptr16
fp            .dsb  2                   ; Frame pointer - points to the base of the local variables of the procedure that are kept in memory (the stack frame) @ptr16
sp            .dsb  2                   ; Stack pointer - points to the top of the stack @ptr16

tmp0          .dsb  2
tmp1          .dsb  2
tmp2          .dsb  2
tmp3          .dsb  2
tmp4          .dsb  2
tmp5          .dsb  2
tmp6          .dsb  2
tmp7          .dsb  2

op1           .dsb  2
op2           .dsb  2

tmp           .dsb  2

reg0          .dsb  2
reg1          .dsb  2
reg2          .dsb  2
reg3          .dsb  2
reg4          .dsb  2
reg5          .dsb  2
reg6          .dsb  2
reg7          .dsb  2

;
; VIA hardware addresses
;
#define VIA_PORTB $0300                 ; Input/Output register B
#define VIA_PORTAH $0301                ; Input/Output register A (with handshake)
#define VIA_DDRB $0302                  ; Data Direction Register B
#define VIA_DDRA $0303                  ; Data Direction Register A
#define VIA_T1CL $0304                  ; Timer 1 low-order latches/counter
#define VIA_T1CH $0305                  ; Timer 1 high-order counter
#define VIA_T1LL $0306                  ; Timer 1 low-order latches
#define VIA_T1LH $0307                  ; Timer 1 high-order latches
#define VIA_T2LL $0308                  ; Timer 2 low-order latches/counter
#define VIA_T2CH $0309                  ; Timer 2 high-order counter
#define VIA_SR $030A                    ; Shift Register (Buggy on many Oric, do not use)
#define VIA_ACR $030B                   ; Auxiliary Control Register
#define VIA_PCR $030C                   ; Peripheral Control Register
#define VIA_IFR $030D                   ; Interupt Flag Register
#define VIA_IER $030E                   ; Interupt Enable Register
#define VIA_PORTA $030F                 ; Input/Output register A (without handshake)

#define VIA2_PORTB $0320                ; The Telestrat has a second VIA

zp_compiler_save_end


.text

; ---------------------------------------------------------------------
osdk_stack    =     __stack
; ---------------------------------------------------------------------

osdk_start
;           @ jmp osdk_start     ; Comment out to not autostart the system

;           @ #include "adress.tmp"
;           @ *=$800

;           @
;           @ Needs to clear the BSS section
;           @




;           @ Debugger module id: stamp _osdk_dbg_module as the very first thing a module
;           @ runs (C or asm), so the VS Code debugger auto-switches to the matching overlay.
;           @ Transparent: only compiled when the build defines OSDK_MODULE_ID (per-overlay
;           @ -DOSDK_MODULE_ID=<id>); other OSDK programs never define it, so it's a no-op —
;           @ and the OSDK-namespaced name avoids clashing with a project's own 'MODULE'.

; #ifdef OSDK_MODULE_ID
;               lda   #OSDK_MODULE_ID
;               sta   _osdk_dbg_module
; #endif

              tsx
              lda   #<osdk_stack
              sta   sp
              lda   #>osdk_stack
              sta   sp+1
              ldy   #0
              stx   retstack
              jmp   _main
retstack
              .byt  0

; enter/leave (the C stack-frame helpers) live in lib/frame.s so that
; programs whose functions are all frameless (-O2+ omit_frame) don't pay
; their bytes.

jsrvect
              jmp   (0000)

_exit
              ldx   retstack
              txs
              rts

reterr
              lda   #$ff                ; return -1
              tax
              rts

retzero
false
              lda   #0                  ;return 0
              tax
              rts

true
              ldx   #1                  ;return 1
              lda   #0
              rts


#define load_acc1   $DE7B
#define load_acc2   $DD51
#define store_acc   $DEAD
#define fadd        $DB25
#define fsub        $DB0E
#define fmul        $DCF0
#define fdiv        $DDE7
#define fneg        $E271
#define fcomp       $DF4C
#define givayf $DF40                    ; UNSIGNED 16bit A(high)/Y(low) to FPA (forces the sign
;           @ byte positive). The historical cif value $DF24 was
;           @ wrong: that is SGN's tail, converting only the signed
;           @ 8bit value in A.

; The int<->float conversion routines (cif/cfi) live in lib/float.s so
; that only programs using floating point pay their bytes.

