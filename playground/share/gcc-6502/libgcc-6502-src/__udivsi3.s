        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        ; This might as well use the _eN registers instead of clobbering the
        ; _sN registers. FIXME!
        .export __udivsi3
__udivsi3:
        .scope
        lda _s0
        pha
        lda _s1
        pha
        lda _s2
        pha
        lda _s3
        pha
        lda _s4
        pha
        lda _s5
        pha
        lda _s6
        pha
        lda _s7
        pha

        lda #0
        sta _s0 ; quotient
        sta _s1
        sta _s2
        sta _s3
        sta _s4 ; remainder
        sta _s5
        sta _s6
        sta _s7

        ldx #32
loop:
        asl _r0 ; shift numerator
        rol _r1
        rol _r2
        rol _r3
        rol _s4 ; left-shift remainder
        rol _s5
        rol _s6
        rol _s7

        sec
        lda _s4
        sbc _r4
        pha
        lda _s5
        sbc _r5
        pha
        lda _s6
        sbc _r6
        pha
        lda _s7
        sbc _r7
        bcc less
        rol _s0
        rol _s1
        rol _s2
        rol _s3
        sta _s7
        pla
        sta _s6
        pla
        sta _s5
        pla
        sta _s4
        jmp next_bit
less:
        pla
        pla
        pla
        asl _s0
        rol _s1
        rol _s2
        rol _s3
next_bit:
        dex
        bne loop

        ; Put quotient in the right place
        lda _s0
        sta _r0
        lda _s1
        sta _r1
        lda _s2
        sta _r2
        lda _s3
        sta _r3

        ; Stash remainder too
        lda _s4
        sta _r4
        lda _s5
        sta _r5
        lda _s6
        sta _r6
        lda _s7
        sta _r7

        pla
        sta _s7
        pla
        sta _s6
        pla
        sta _s5
        pla
        sta _s4
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
