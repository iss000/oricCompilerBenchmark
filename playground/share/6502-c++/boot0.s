.setcpu         "6502"
.autoimport     on
.case           on
.debuginfo      off

.exportzp       zpreg_00
.exportzp       zpreg_01
.exportzp       zpreg_02
.exportzp       zpreg_03
.exportzp       zpreg_04
.exportzp       zpreg_05
.exportzp       zpreg_06
.exportzp       zpreg_07
.exportzp       zpreg_08
.exportzp       zpreg_09
.exportzp       zpreg_0a
.exportzp       zpreg_0b
.exportzp       zpreg_0c
.exportzp       zpreg_0d
.exportzp       zpreg_0e
.exportzp       zpreg_0f
.exportzp       zpreg_10
.exportzp       zpreg_11
.exportzp       zpreg_12
.exportzp       zpreg_13
.exportzp       zpreg_14
.exportzp       zpreg_15
.exportzp       zpreg_16
.exportzp       zpreg_17
.exportzp       zpreg_18
.exportzp       zpreg_19
.exportzp       zpreg_1a
.exportzp       zpreg_1b
.exportzp       zpreg_1c
.exportzp       zpreg_1d
.exportzp       zpreg_1e
.exportzp       zpreg_1f

; .importzp       sp
.exportzp       sp
.exportzp       sreg
; .importzp       sreg, regsave, regbank
; .importzp       tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4

.export         __STARTUP__ ; required and used internally
.import         _main

.segment        "ZEROPAGE"

; __CCP__         = 0x3c
; __SP_L__        = 0x3d
; __SP_H__        = 0x3e
; __SREG__        = 0x3f

zpreg_00:       .res  1
zpreg_01:       .res  1
zpreg_02:       .res  1
zpreg_03:       .res  1
zpreg_04:       .res  1
zpreg_05:       .res  1
zpreg_06:       .res  1
zpreg_07:       .res  1
zpreg_08:       .res  1
zpreg_09:       .res  1
zpreg_0a:       .res  1
zpreg_0b:       .res  1
zpreg_0c:       .res  1
zpreg_0d:       .res  1
zpreg_0e:       .res  1
zpreg_0f:       .res  1
zpreg_10:       .res  1
zpreg_11:       .res  1
zpreg_12:       .res  1
zpreg_13:       .res  1
zpreg_14:       .res  1
zpreg_15:       .res  1
zpreg_16:       .res  1
zpreg_17:       .res  1
zpreg_18:       .res  1
zpreg_19:       .res  1
zpreg_1a:       .res  1
zpreg_1b:       .res  1
zpreg_1c:       .res  1
zpreg_1d:       .res  1
zpreg_1e:       .res  1
zpreg_1f:       .res  1

sp:             .res  2
sreg:           .res  2

; regsave:        .res  2
; regbank:        .res  2
;
; tmp1:           .res  1
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
                lda   #<__stack
                sta   sp
                lda   #>__stack
                sta   sp+1

                jmp   _main
