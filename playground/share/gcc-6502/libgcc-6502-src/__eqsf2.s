        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        .export __eqsf2
__eqsf2:
        .scope
        lda _r2
        and #$7f
        ora _r3
        ora _r1
        ora _r0
        bne not_plusminus_zero

        lda _r6
        and #$7f
        ora _r7
        ora _r5
        ora _r4
        beq eq

not_plusminus_zero:
        lda _r0
        cmp _r4
        bne ne
        lda _r1
        cmp _r5
        bne ne
        lda _r2
        cmp _r6
        bne ne
        lda _r3
        cmp _r7
        bne ne
eq:
        lda #1
        sta _r0
        rts
ne:
        lda #0
        sta _r0
        rts
        .endscope
