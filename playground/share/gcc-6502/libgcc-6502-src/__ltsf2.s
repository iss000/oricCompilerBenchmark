        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        .export __m65x_fpcmp
        ; Helper routine used by ltsf/lesf/gtsf/gesf. This has to go
        ; somewhere, so put it here.
        ; On entry the Y register has
        ; - zero for a regular comparison
        ; - nonzero for a reversed comparison
        ; On exit the accumulator has
        ; - 0x80 for "less than" result
        ; - zero for "greater than or equal" result.
__m65x_fpcmp:
        .scope
        lda _r2
        tax
        and #$80
        sta _tmp0
        txa
        and #$7f
        sta _r2

        lda _r6
        tax
        and #$80
        sta _tmp1
        txa
        and #$7f
        sta _r6

        ; -X < -Y == X > Y == Y < X
        lda _tmp0
        and _tmp1
        bpl not_both_negative
        jmp maybe_reverse_cmp
not_both_negative:
        lda _tmp0
        eor _tmp1
        bpl not_one_only
        ; Now we have one of:
        ; -X < Y
        ; X < -Y
        ; -X > Y (reversed)
        ; X > -Y
        cpy #0
        bne reverse
        lda _tmp0
        rts
reverse:
        lda _tmp1
        rts
not_one_only:

        cpy #0
        bne reverse_cmp
forward_cmp:
        .scope
        ; mantissa
        lda _r0
        cmp _r4
        lda _r1
        sbc _r5
        lda _r2
        sbc _r6
        ; exponent
        lda _r3
        sbc _r7
        bcc less
        lda #0
        rts
less:
        lda #$80
        rts
        .endscope

maybe_reverse_cmp:
        cpy #0
        bne forward_cmp
reverse_cmp:
        .scope
        ; mantissa
        lda _r4
        cmp _r0
        lda _r5
        sbc _r1
        lda _r6
        sbc _r2
        ; exponent
        lda _r7
        sbc _r3
        bcc less
        lda #0
        rts
less:
        lda #$80
        rts
        .endscope
        .endscope

        .export __ltsf2
__ltsf2:
        ldy #0
        jsr __m65x_fpcmp
        sta _r0
        rts
