; void *memccpy(void *dest, const void *src, int c, unsigned int n)
;
; Copies at most n bytes from src to dest, stopping after the first byte
; equal to (unsigned char)c has been copied. Returns a pointer to the byte
; AFTER c in dest, or NULL if c was not found in the first n bytes.
;
; Rewritten standalone: the old version patched a byte inside strncpy and
; jumped to a label (cpycommon) that no longer exists, so it had not linked
; since the strncpy rewrite.

_memccpy
        jsr get_2ptr    ; op1 = dest, op2 = src

        ldy #4          ; tmp = (unsigned char)c
        lda (sp),y
        sta tmp

        ldy #6          ; two-counter setup: X = lo(n)+1, tmp1 = hi(n)+1,
        lda (sp),y      ; so the loop only needs dex / dec, no 16 bit test
        tax
        iny
        lda (sp),y
        sta tmp1
        inx
        inc tmp1

        ldy #0
memccpyloop
        dex             ; n--
        bne memccpy1
        dec tmp1
        beq memccpyfail ; n exhausted, c not found
memccpy1
        lda (op2),y     ; copy one byte
        sta (op1),y
        cmp tmp         ; was it c?
        beq memccpyhit
        iny
        bne memccpyloop
        inc op1+1       ; both pointers crossed a page
        inc op2+1
        jmp memccpyloop

memccpyhit
        sec             ; return dest+Y+1 (the byte after c), A=high X=low
        tya
        adc op1
        tax
        lda op1+1
        adc #0
        rts

memccpyfail
        jmp retzero
