        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        .import __floatunsisf
        .export __floatsisf
__floatsisf:
        lda _r3
        and #$80
        sta _m65x_fpe0_sign
        bpl not_negative
        ldx #0
        txa
        sec
        sbc _r0
        sta _r0
        txa
        sbc _r1
        sta _r1
        txa
        sbc _r2
        sta _r2
        txa
        sbc _r3
        sta _r3
not_negative:
        jsr __floatunsisf

        lda _r2
        ora _m65x_fpe0_sign
        sta _r2

        rts
