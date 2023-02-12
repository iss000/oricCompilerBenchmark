        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        .export __mulsi3
__mulsi3:
        .scope
        lda _s0
        pha
        lda _s1
        pha
        lda _s2
        pha
        lda _s3
        pha

        lda #0
        sta _s0
        sta _s1
        sta _s2
        sta _s3

        ldx #32
loop:
        lsr _r7
        ror _r6
        ror _r5
        ror _r4
        bcc no_add
        clc
        lda _s0
        adc _r0
        sta _s0
        lda _s1
        adc _r1
        sta _s1
        lda _s2
        adc _r2
        sta _s2
        lda _s3
        adc _r3
        sta _s3
no_add:
        asl _r0
        rol _r1
        rol _r2
        rol _r3

        dex
        bne loop

        lda _s0
        sta _r0
        lda _s1
        sta _r1
        lda _s2
        sta _r2
        lda _s3
        sta _r3

        pla
        sta _s3
        pla
        sta _s2
        pla
        sta _s1
        pla
        sta _s0
        rts
        .endscope
