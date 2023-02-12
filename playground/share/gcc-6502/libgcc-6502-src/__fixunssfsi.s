        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        .export __fixunssfsi
__fixunssfsi:
        lda _r2
        and #$7f
        ldx _r3
        beq a_exp_zero
        ora #$80
a_exp_zero:
        sta _r2
        stx _m65x_fpe0_exp

        cpx #127
        bcs over_one
        lda #0
        sta _r0
        sta _r1
        sta _r2
        sta _r3
        rts
over_one:

        ; r3 is part of the result now.
        lda #0
        sta _r3

        .scope
        lda #150
        sec
        sbc _m65x_fpe0_exp
        bcc shift_left
        ; shifting right by 'A' places
        tax
        beq exit
right_shift_loop:
        lsr _r3
        ror _r2
        ror _r1
        ror _r0
        dex
        bne right_shift_loop
exit:
        rts
shift_left:
        eor #$ff
        tax
        inx
left_shift_loop:
        asl _r0
        rol _r1
        rol _r2
        rol _r3
        dex
        bne left_shift_loop
        .endscope

        rts
