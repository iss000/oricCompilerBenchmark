        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        ; A plain implementation of the "Integer division (unsigned) with
        ; remainder" algorithm given on Wikipedia:
        ; [if D == 0 then error(DivisionByZeroException) end]
        ; Q := 0 -- initialize quotient and remainder to zero
        ; R := 0
        ; for i = n-1...0 do -- where n is number of bits in N
        ; R := R << 1 -- left-shift R by 1 bit
        ; R(0) := N(i) -- set the least-significant bit of R equal
        ; if R >= D then to bit i of the numerator
        ; R = R - D
        ; Q(i) := 1
        ; end
        ; end
        .import _m65x_renormalize_left
        .export __divsf3
__divsf3:
        lda _s2
        pha
        lda _s1
        pha
        lda _s0
        pha

        lda _r2
        eor _r6
        and #$80
        sta _m65x_fpe0_sign

        .scope
        lda _r2
        and #$7f
        ldx _r3
        beq a_exp_zero
        ora #$80
a_exp_zero:
        sta _r2
        stx _m65x_fpe0_exp

        lda _r6
        and #$7f
        ldx _r7
        beq b_exp_zero
        ora #$80
b_exp_zero:
        sta _r6
        stx _m65x_fpe1_exp
        .endscope

        lda #0
        sta _s2
        sta _s1
        sta _s0

        ; Result goes here. We want the eventual answer in fpe0_mant+[1,2,3].
        sta _m65x_fpe0_mant
        sta _m65x_fpe0_mant+1
        sta _m65x_fpe0_mant+2
        sta _m65x_fpe0_mant+3
        sta _m65x_fpe0_mant+4
        sta _r3

        ; The remainder
        sta _m65x_fpe1_mant
        sta _m65x_fpe1_mant+1
        sta _m65x_fpe1_mant+2
        sta _m65x_fpe1_mant+3
        sta _m65x_fpe1_mant+4
        sta _r7

        ; r2,r1,r0,s2,s1,s0 = a_mant << 23

        lsr _r2
        ror _r1
        ror _r0
        ror _s2
        ror _s1
        ror _s0

        ; result[47:0] = r2,r1,r0,s2,s1,s0 / r6,r5,r4
        .scope
        ldx #48
loop:
        ; get the i'th bit of N (starting from highest-order bit).
        asl _s0
        rol _s1
        rol _s2
        rol _r0
        rol _r1
        rol _r2
        ; R = (R << 1) | (N[i] ? 1 : 0)
        rol _m65x_fpe1_mant
        rol _m65x_fpe1_mant+1
        rol _m65x_fpe1_mant+2
        rol _m65x_fpe1_mant+3
        rol _m65x_fpe1_mant+4
        rol _r7

        ; Test D <= R
        sec
        lda _m65x_fpe1_mant
        sbc _r4
        pha
        lda _m65x_fpe1_mant+1
        sbc _r5
        pha
        lda _m65x_fpe1_mant+2
        sbc _r6
        pha
        lda _m65x_fpe1_mant+3
        sbc #0
        pha
        lda _m65x_fpe1_mant+4
        sbc #0
        pha
        lda _r7
        sbc #0
        bcc less
        rol _m65x_fpe0_mant+1
        rol _m65x_fpe0_mant+2
        rol _m65x_fpe0_mant+3
        rol _m65x_fpe0_mant+4
        rol _m65x_fpe0_mant
        rol _r3
        sta _r7
        pla
        sta _m65x_fpe1_mant+4
        pla
        sta _m65x_fpe1_mant+3
        pla
        sta _m65x_fpe1_mant+2
        pla
        sta _m65x_fpe1_mant+1
        pla
        sta _m65x_fpe1_mant
        jmp next_bit
less:
        pla
        pla
        pla
        pla
        pla
        asl _m65x_fpe0_mant+1
        rol _m65x_fpe0_mant+2
        rol _m65x_fpe0_mant+3
        rol _m65x_fpe0_mant+4
        rol _m65x_fpe0_mant
        rol _r3
next_bit:
        dex
        bne loop
        .endscope

        ; Remove junk in high-order & low-order bits.
        lda #0
        sta _m65x_fpe0_mant
        sta _m65x_fpe0_mant+4

        ; High-order exponent byte.
        ldx #0

        lda _m65x_fpe0_exp
        sec
        sbc _m65x_fpe1_exp
        sta _m65x_fpe0_exp
        bcs :+
        dex
        :

        lda _m65x_fpe0_exp
        clc
        adc #127
        sta _m65x_fpe0_exp
        bcc :+
        inx
        :

        ; FIXME: Handle exponent overflow/underflow here.

        .scope
        lda _m65x_fpe0_mant+1
        ora _m65x_fpe0_mant+2
        ora _m65x_fpe0_mant+3
        bne not_zero
        sta _m65x_fpe0_exp
        jmp done
not_zero:
        jsr _m65x_renormalize_left
done:
        .endscope

        lda _m65x_fpe0_mant+1
        sta _r0
        lda _m65x_fpe0_mant+2
        sta _r1
        lda _m65x_fpe0_mant+3
        and #$7f
        ora _m65x_fpe0_sign
        sta _r2
        lda _m65x_fpe0_exp
        sta _r3

        pla
        sta _s0
        pla
        sta _s1
        pla
        sta _s2

        rts
