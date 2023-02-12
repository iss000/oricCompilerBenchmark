        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        .import _m65x_renormalize_left
        .import _m65x_renormalize_right
        .export __floatunsisf
__floatunsisf:
        ; All zero, just return zero.
        lda _r0
        ora _r1
        ora _r2
        ora _r3
        bne notzero
        rts
notzero:

        lda #150
        sta _m65x_fpe0_exp
        lda #0
        sta _m65x_fpe0_mant

        lda _r0
        sta _m65x_fpe0_mant+1
        lda _r1
        sta _m65x_fpe0_mant+2
        ldx _r2
        stx _m65x_fpe0_mant+3
        lda _r3
        sta _m65x_fpe0_mant+4

        bne rightshift
        cpx #$80
        bcs rightshift
        ; We need to shift left until the mantissa is normalized.
        jsr _m65x_renormalize_left
        jmp repack
rightshift:
        jsr _m65x_renormalize_right
repack:

        bit _m65x_fpe0_mant
        bpl no_rounding
        inc _m65x_fpe0_mant+1
        bne no_rounding
        inc _m65x_fpe0_mant+2
        bne no_rounding
        inc _m65x_fpe0_mant+3
        bne no_rounding
        inc _m65x_fpe0_mant+4
        jsr _m65x_renormalize_right
no_rounding:

        lda _m65x_fpe0_mant+1
        sta _r0
        lda _m65x_fpe0_mant+2
        sta _r1
        lda _m65x_fpe0_mant+3
        and #$7f
        sta _r2
        lda _m65x_fpe0_exp
        sta _r3

        rts
