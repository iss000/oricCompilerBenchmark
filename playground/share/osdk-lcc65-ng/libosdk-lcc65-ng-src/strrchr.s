; char *strrchr(char *s, char c)
;
; Fixes vs the previous version:
; - the returned address was computed with the CURRENT (scan-advanced) high
;   byte of the string pointer, so any string longer than 256 bytes returned
;   a pointer too high by the number of pages crossed; the original high
;   byte is now saved at entry (tmp2) and used for the result.
; - C89: the terminating null is part of the string, so strrchr(s,'\0')
;   returns a pointer to the terminator (the compare now happens before the
;   end-of-string test, like the strchr fix).

_strrchr
        ldy #0
        lda (sp),y
        sta strrchr1+1  ; low(s)
        iny
        lda (sp),y
        sta strrchr1+2  ; high(s), advanced during the scan
        sta tmp2        ; high(s), original (for the returned pointer)
        iny
        lda (sp),y
        sta strrchr1+4  ; c, patched into the compare below
        lda #00
        sta tmp1        ; found flag
        ldx #0          ; low index within the current page
        ldy #0          ; pages crossed

strrchr1                ; loop through the string
        lda $2211,X
        cmp #$06        ; the searched character (patched above)
        beq strrchr1a
        cmp #0          ; end of the string?
        beq strrchr2

strrchr1b
        inx
        bne strrchr1
        inc strrchr1+2
        iny
        jmp strrchr1

strrchr1a
        pha             ; A = the matched character (== c)
        stx tmp0        ; found an occurrence, store the offset to it
        sty tmp0+1
        lda #$01
        sta tmp1        ; flag found=1
        pla             ; searching for '\0'? then the terminator match
        bne strrchr1b   ; ends the scan (C89); else keep looking
                        ; (fall through: c was '\0', we are done)
strrchr2
        lda tmp1
        beq strrchr3    ; found character?

        clc             ; character found, return pointer to it within s
        lda tmp0
        adc strrchr1+1
        tax             ; low order byte
        lda tmp0+1
        adc tmp2        ; high order byte (the ORIGINAL one, plus pages)
        rts

strrchr3
        jmp retzero     ; character not found, return NULL
