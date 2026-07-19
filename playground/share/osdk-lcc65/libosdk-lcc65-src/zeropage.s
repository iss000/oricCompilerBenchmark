;
; Zero page sheltering for ROM/DOS interop.
;
; _zp_swap exchanges the C runtime zero page block (ap..zp_compiler_save_end,
; i.e. ap/fp/sp, the tmp/op scratch and the register variables) with an
; internal buffer. It is a SWAP, hence self-inverse: call it once to shelter
; the C runtime before borrowing the zero page for ROM or DOS calls, and
; once more to restore everything - one routine, one buffer, and the buffer
; needs no initialisation.
;
; Only the compiler block is swapped: the rest of page 0 (BASIC workspace,
; CHRGET at $E2, TXTPTR, the float accus...) stays LIVE, which is exactly
; what ROM and SEDORIC code expects to find. Between the two calls the C
; runtime must not be used (no C calls, no compiler macros touching
; ap/fp/sp/tmp/reg) - but the sheltered block may be freely scribbled on.
;
; The block bounds come from the zp_crt.inc labels, so a project that
; relocates OSDK_ZP_START is handled automatically.
;
; Size: 17 bytes of code + (zp_compiler_save_end-ap) bytes of buffer (44
; with the default layout). See sedoric.s for a user.
;

_zp_swap
.(
        php
        sei             ; no IRQ may see the half-swapped state
        ldx #(zp_compiler_save_end-ap)-1
loop
        lda ap,x
        ldy zp_swap_buffer,x
        sta zp_swap_buffer,x
        tya
        sta ap,x
        dex
        bpl loop
        plp
        rts

zp_swap_buffer
        .dsb zp_compiler_save_end-ap
.)
