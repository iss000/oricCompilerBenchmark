; char *strchr(char *s, char c)

_strchr
        ldy #0
        lda (sp),y
        sta strchr1+1   ; low(s)
        iny
        lda (sp),y
        sta strchr1+2   ; high(s)
        iny
        lda (sp),y
        sta strchr1+4   ; low(c) - operand of the cmp right after the lda
        ldx #0

strchr1
        lda $2211,X
        cmp #$06        ; compare BEFORE the end-of-string test: the
        beq strchr3     ; terminator is part of the string per C89, so
        cmp #0          ; strchr(s,'\0') must find it, not return NULL
        beq strchr2
        inx
        bne strchr1
        inc strchr1+2
        jmp strchr1

strchr2
        jmp retzero     ; character not found, return NULL

strchr3
        clc             ; character found, return pointer to it within s
        txa
        adc strchr1+1
        tax
        lda strchr1+2
        adc #0
        rts

