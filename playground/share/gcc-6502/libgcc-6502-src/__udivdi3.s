        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        .export __udivdi3
__udivdi3:
        lda #0
        ldx #0
        ; e0...e7 are the quotient.
        ; e8...e15 are the remainder.
clear:
        sta _e0,x
        inx
        cpx #16
        bne clear

        ldx #64
loop:
        asl _r0 ; shift numerator
        rol _r1
        rol _r2
        rol _r3
        rol _r4
        rol _r5
        rol _r6
        rol _r7
        rol _e8 ; left-shift remainder
        rol _e9
        rol _e10
        rol _e11
        rol _e12
        rol _e13
        rol _e14
        rol _e15

        ldy #0
        sec
        lda _e8
        sbc (_sp0),y
        pha
        iny
        lda _e9
        sbc (_sp0),y
        pha
        iny
        lda _e10
        sbc (_sp0),y
        pha
        iny
        lda _e11
        sbc (_sp0),y
        pha
        iny
        lda _e12
        sbc (_sp0),y
        pha
        iny
        lda _e13
        sbc (_sp0),y
        pha
        iny
        lda _e14
        sbc (_sp0),y
        pha
        iny
        lda _e15
        sbc (_sp0),y
        bcc less
        rol _e0
        rol _e1
        rol _e2
        rol _e3
        rol _e4
        rol _e5
        rol _e6
        rol _e7
        sta _e15
        pla
        sta _e14
        pla
        sta _e13
        pla
        sta _e12
        pla
        sta _e11
        pla
        sta _e10
        pla
        sta _e9
        pla
        sta _e8
        jmp next_bit
less:
        pla
        pla
        pla
        pla
        pla
        pla
        pla
        asl _e0
        rol _e1
        rol _e2
        rol _e3
        rol _e4
        rol _e5
        rol _e6
        rol _e7
next_bit:
        dex
        beq done
        ; Tsk, out of range!
        jmp loop
done:

        ; Put quotient in the right place
        ldx #0
copyout:
        lda _e0,x
        sta _r0,x
        inx
        cpx #8
        bne copyout

        rts
