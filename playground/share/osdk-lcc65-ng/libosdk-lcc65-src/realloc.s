; void *realloc(void *mem_address, unsigned int newsize)
;
; Clean rewrite (the original in-place/grow logic was broken in every path:
; a signed size comparison, a shrink path that read/wrote the wrong descriptor
; field, and a grow path whose stack-based memcpy hack never actually resized
; or re-accounted the block).
;
;   realloc(NULL, n)  -> malloc(n)
;   realloc(p, 0)     -> free(p), return NULL
;   shrink (newsize <= current): adjust the block in place
;   grow   (newsize >  current): malloc a new block, copy the old contents,
;                                free the old block
;
; Blocks carry a per-block descriptor of _heapovh bytes; memdesc->len (at
; offset 2/3) is the TOTAL block size (usable size + _heapovh), matching the
; convention malloc/free use. op1/op2/tmp/tmp5..tmp7 survive _mallocmc and
; _freemc (which only touch tmp0..tmp4); we keep realloc's state there.

_realloc
        jsr get_2ptr            ; op1 = mem_address, op2 = newsize

        lda op1                 ; if(!mem_address) return malloc(newsize)
        ora op1+1
        bne realloc_have
        lda op2
        ldx op2+1
        jmp _mallocmc

realloc_have
        lda op2                 ; if(!newsize) { free(mem_address); return NULL }
        ora op2+1
        bne realloc_resize
        lda op1
        ldx op1+1
        jsr _freemc
        jmp retzero

realloc_resize
        lda op1                 ; tmp0 = memdesc = mem_address - heapovh
        sec
        sbc _heapovh
        sta tmp0
        lda op1+1
        sbc #0
        sta tmp0+1

        clc                     ; tmp1 = wanted = newsize + heapovh
        lda op2
        adc _heapovh
        sta tmp1
        lda op2+1
        adc #0
        sta tmp1+1

        ldy #3                  ; compare memdesc->len vs wanted (unsigned)
        lda (tmp0),y            ; len high
        cmp tmp1+1
        bcc realloc_grow        ; len < wanted -> grow
        bne realloc_shrink      ; len > wanted -> shrink
        dey
        lda (tmp0),y            ; len low
        cmp tmp1
        bcc realloc_grow        ; len < wanted -> grow
                                ; len >= wanted -> shrink in place

realloc_shrink
        ldy #2                  ; tmp = memdesc->len - wanted (bytes released)
        sec
        lda (tmp0),y
        sbc tmp1
        sta tmp
        iny
        lda (tmp0),y
        sbc tmp1+1
        sta tmp+1

        sec                     ; _nheapbytes -= tmp
        lda _nheapbytes
        sbc tmp
        sta _nheapbytes
        lda _nheapbytes+1
        sbc tmp+1
        sta _nheapbytes+1

        ldy #2                  ; memdesc->len = wanted
        lda tmp1
        sta (tmp0),y
        iny
        lda tmp1+1
        sta (tmp0),y

        lda op1+1               ; return the same buffer (A=hi, X=lo)
        ldx op1
        rts

realloc_grow
        ldy #2                  ; tmp5 = old usable size = memdesc->len - heapovh
        sec                     ; (bytes to copy; safe across malloc/free)
        lda (tmp0),y
        sbc _heapovh
        sta tmp5
        iny
        lda (tmp0),y
        sbc #0
        sta tmp5+1

        lda op1                 ; tmp7 = copy source = old mem_address
        sta tmp7                ; (op1 is kept intact for the free below)
        lda op1+1
        sta tmp7+1

        lda op2                 ; new = malloc(newsize)
        ldx op2+1
        jsr _mallocmc           ; returns A=hi, X=lo (0,0 on failure)

        sta tmp6+1              ; tmp6 = new pointer (return value, untouched)
        stx tmp6
        sta op2+1               ; op2 = copy destination (gets incremented)
        stx op2

        lda tmp6                ; if(new == NULL) return NULL (old block intact)
        ora tmp6+1
        bne realloc_copy
        jmp retzero

realloc_copy                    ; copy tmp5 bytes from (tmp7) to (op2)
        ldx tmp5+1              ; whole pages first
        beq realloc_copytail
realloc_copypage
        ldy #0
realloc_copypl
        lda (tmp7),y
        sta (op2),y
        iny
        bne realloc_copypl
        inc tmp7+1
        inc op2+1
        dex
        bne realloc_copypage
realloc_copytail
        ldy tmp5               ; remaining 0..255 bytes
        beq realloc_freeold
        ldy #0
realloc_copyrem
        lda (tmp7),y
        sta (op2),y
        iny
        cpy tmp5
        bne realloc_copyrem

realloc_freeold
        lda op1                 ; free(old mem_address)
        ldx op1+1
        jsr _freemc

        lda tmp6+1              ; return the new buffer (A=hi, X=lo)
        ldx tmp6
        rts
