        .importzp _sp0, _sp1, _fp0, _fp1
        .importzp _r0, _r1, _r2, _r3, _r4, _r5, _r6, _r7
        .importzp _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7
        .importzp _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7
        .importzp _e8, _e9, _e10, _e11, _e12, _e13, _e14, _e15
        .importzp _tmp0, _tmp1
        .importzp _m65x_fpe0_mant, _m65x_fpe0_exp, _m65x_fpe0_sign
        .importzp _m65x_fpe1_mant, _m65x_fpe1_exp, _m65x_fpe1_sign
        .import _m65x_renormalize_right
        .export __mulsf3
__mulsf3:
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
        stx _m65x_fpe1_exp
        tax
        .endscope

        lda _r4
        sta _r3
        lda _r5
        sta _r4
        stx _r5

        ; Do the actual multiplication.
        .scope

        lda #0
        sta _r6
        sta _r7
        sta _m65x_fpe0_mant
        sta _m65x_fpe0_mant+1
        sta _m65x_fpe0_mant+2
        sta _m65x_fpe0_mant+3
        sta _m65x_fpe0_mant+4

        ; s2,s1,s0,r2,r1,r0
        sta _s0
        sta _s1
        sta _s2

        ldx #24
loop:
        lsr _r5
        ror _r4
        ror _r3
        bcc no_add
        clc
        lda _r6
        adc _r0
        sta _r6
        lda _r7
        adc _r1
        sta _r7
        lda _m65x_fpe0_mant
        adc _r2
        sta _m65x_fpe0_mant
        lda _m65x_fpe0_mant+1
        adc _s0
        sta _m65x_fpe0_mant+1
        lda _m65x_fpe0_mant+2
        adc _s1
        sta _m65x_fpe0_mant+2
        lda _m65x_fpe0_mant+3
        adc _s2
        sta _m65x_fpe0_mant+3
        bcc :+
        inc _m65x_fpe0_mant+4
        :
no_add:
        asl _r0
        rol _r1
        rol _r2
        rol _s0
        rol _s1
        rol _s2
        dex
        bne loop

        asl _r6
        rol _r7
        rol _m65x_fpe0_mant
        rol _m65x_fpe0_mant+1
        rol _m65x_fpe0_mant+2
        rol _m65x_fpe0_mant+3
        rol _m65x_fpe0_mant+4

        .endscope

        ldx #0

        lda _m65x_fpe0_exp
        clc
        adc _m65x_fpe1_exp
        sta _m65x_fpe0_exp
        bcc :+
        inx
        :

        lda _m65x_fpe0_exp
        sec
        sbc #127
        sta _m65x_fpe0_exp
        bcs :+
        dex
        :
        ; FIXME: clamping to zero/max_float goes here.

        .scope
        lda _m65x_fpe0_mant+1
        ora _m65x_fpe0_mant+2
        ora _m65x_fpe0_mant+3
        bne not_zero
        sta _m65x_fpe0_exp
        jmp done
not_zero:
        jsr _m65x_renormalize_right
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
