        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        .import __umodsi3
        .import __negsi2
        .export __modsi3
__modsi3:
        lda _r3
        pha

        bpl numerator_positive
        jsr __negsi2
numerator_positive:
        lda _r7
        bpl denominator_positive
        ldx #0
        txa
        sec
        sbc _r4
        sta _r4
        txa
        sbc _r5
        sta _r5
        txa
        sbc _r6
        sta _r6
        txa
        sbc _r7
        sta _r7
denominator_positive:
        jsr __umodsi3
        pla
        bpl result_positive
        ; tailcall
        jmp __negsi2
result_positive:
        rts
