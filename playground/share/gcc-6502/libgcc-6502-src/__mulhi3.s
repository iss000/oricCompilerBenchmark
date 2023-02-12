        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        .export __mulhi3
__mulhi3:
        ldx #0
        ldy #0
loop:
        lsr _r1
        ror _r0
        bcc no_add
        txa
        clc
        adc _r2
        tax
        tya
        adc _r3
        tay
no_add:
        asl _r2
        rol _r3
        lda _r2
        ora _r3
        bne loop
        stx _r0
        sty _r1
        rts
