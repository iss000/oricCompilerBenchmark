; char *strtok(char *s, char *delim)
;
; C89 semantics: with a non-NULL s a new scan starts, with NULL it
; continues after the previous token. Leading delimiters are skipped
; (consecutive delimiters produce no empty tokens), the token is
; terminated in place, and once the string is exhausted every further
; call returns NULL.
;
; Uses tmp as the scan cursor, op1 for the delimiter set and op2 to
; hold the token start across the scan.

_strtok
        ldy #2                  ; delim -> op1
        lda (sp),y
        sta op1
        iny
        lda (sp),y
        sta op1+1

        ldy #0                  ; s -> tmp, NULL means continue
        lda (sp),y
        sta tmp
        iny
        lda (sp),y
        sta tmp+1
        ora tmp
        bne stokskip
        lda strtokp             ; s == NULL: resume from saved pointer
        sta tmp
        lda strtokp+1
        sta tmp+1
        ora tmp
        beq stoknull            ; nothing saved: scan is exhausted

stokskip                        ; skip leading delimiters
        ldy #0
        lda (tmp),y
        beq stokdone            ; only delimiters left: exhausted
        jsr stokisdelim
        bcc stoktoken
        inc tmp
        bne stokskip
        inc tmp+1
        jmp stokskip

stoktoken                       ; token starts here
        lda tmp
        sta op2
        lda tmp+1
        sta op2+1
stokscan
        ldy #0
        lda (tmp),y
        beq stokend             ; terminator ends the last token
        jsr stokisdelim
        bcs stokcut
        inc tmp
        bne stokscan
        inc tmp+1
        jmp stokscan

stokcut                         ; delimiter: terminate token in place,
        lda #0                  ; continue after it next time
        tay
        sta (tmp),y
        clc
        lda tmp
        adc #1
        sta strtokp
        lda tmp+1
        adc #0
        sta strtokp+1
        jmp stokret

stokend                         ; token ran to the end of the string
        lda #0
        sta strtokp
        sta strtokp+1
stokret
        ldx op2
        lda op2+1
        rts

stokdone
        lda #0
        sta strtokp
        sta strtokp+1
stoknull
        jmp retzero

; helper: is the character in A part of the delimiter set at (op1)?
; returns carry set if so; clobbers A and Y
stokisdelim
        sta stokchar+1
        ldy #0
stokdloop
        lda (op1),y
        beq stokdno
stokchar
        cmp #0                  ; patched with the searched character
        beq stokdyes
        iny
        bne stokdloop
stokdno
        clc
        rts
stokdyes
        sec
        rts

strtokp
        .byt 0,0
