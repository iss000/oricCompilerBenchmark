        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        .export __muldi3
__muldi3:
        ldy #0
        ldx #0
copyop2:
        lda (_sp0),y
        sta _e0,y
        stx _e8,y
        iny
        cpy #8
        bne copyop2
        ldx #64
loop:
        lsr _r7
        ror _r6
        ror _r5
        ror _r4
        ror _r3
        ror _r2
        ror _r1
        ror _r0
        bcc no_add
        clc
        lda _e8
        adc _e0
        sta _e8
        lda _e9
        adc _e1
        sta _e9
        lda _e10
        adc _e2
        sta _e10
        lda _e11
        adc _e3
        sta _e11
        lda _e12
        adc _e4
        sta _e12
        lda _e13
        adc _e5
        sta _e13
        lda _e14
        adc _e6
        sta _e14
        lda _e15
        adc _e7
        sta _e15
no_add:
        asl _e0
        rol _e1
        rol _e2
        rol _e3
        rol _e4
        rol _e5
        rol _e6
        rol _e7
        dex
        bne loop

        ldx #0
copyout:
        lda _e8,x
        sta _r0,x
        inx
        cpx #8
        bne copyout
        rts
