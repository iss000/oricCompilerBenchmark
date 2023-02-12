        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        .export __cmpdi2
__cmpdi2:
        ldy #0
        lda _r0
        cmp (_sp0),y
        iny
        lda _r1
        sbc (_sp0),y
        iny
        lda _r2
        sbc (_sp0),y
        iny
        lda _r3
        sbc (_sp0),y
        iny
        lda _r4
        sbc (_sp0),y
        iny
        lda _r5
        sbc (_sp0),y
        iny
        lda _r6
        sbc (_sp0),y
        iny
        lda _r7
        sbc (_sp0),y
        bvc no_ov
        eor #$80
no_ov:
        bmi less
        ldy #0
samecheck:
        lda _r0,y
        cmp (_sp0),y
        bne greater
        iny
        cpy #8
        bne samecheck
        lda #1
        sta _r0
        lda #0
        sta _r1
        rts
greater:
        lda #2
        sta _r0
        lda #0
        sta _r1
        rts
less:
        lda #0
        sta _r0
        sta _r1
        rts
