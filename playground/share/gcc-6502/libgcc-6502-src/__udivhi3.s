        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        .export __udivhi3
__udivhi3:
        ; (_r1, _r0) / (_r3, _r2)
        ; quotient in _r5, _r4
        ; remainder in _r7, _r6
        lda #0
        sta _r4
        sta _r5
        sta _r6
        sta _r7
        ldx #16
loop:
        asl _r0 ; left-shift numerator
        rol _r1
        rol _r6 ; shift high-order bit into remainder
        rol _r7
        lda _r6 ; compare remainder with denominator
        sec
        sbc _r2
        tay
        lda _r7
        sbc _r3
        bcc notgreater
        rol _r4
        rol _r5
        sty _r6
        sta _r7
        jmp next
notgreater:
        asl _r4
        rol _r5
next:
        dex
        bne loop
        lda _r4
        sta _r0
        lda _r5
        sta _r1
        rts
