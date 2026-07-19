; void free(unsigned int *p)

_free
        ldy #1                  ; (tmp0) wanted=p-heapovh
        lda (sp),y
        tax
        dey
        lda (sp),y

_freemc                         ; machine code entry pt, A=lo(p), X=hi(p)
        cpx #0                  ; if(!p) return -- test the pointer passed in A/X.
        bne freemc1             ; (This entry does NOT take the arg on the C stack,
        cmp #0                  ;  so the old (sp)-based null check was wrong and
        bne freemc1             ;  could skip a valid free, e.g. when realloc calls
        rts                     ;  _freemc directly.)
freemc1
        sec
        sbc _heapovh
        sta tmp0
        txa
        sbc #0
        sta tmp0+1

free1
        lda #<(_heapdesc)     ; (tmp1) desc = &heapdesc
        sta tmp1
        lda #>(_heapdesc)
        sta tmp1+1

freeloop
        lda tmp1                ; if(!desc)return
        ora tmp1+1
        bne free2
        rts

free2
        ldy #0                  ; (tmp2)next=desc->next
        lda (tmp1),y
        sta tmp2
        tax
        iny
        lda (tmp1),y
        sta tmp2+1

        cpx tmp0                ; if(wanted==next)
        bne freenext
        cmp tmp0+1
        bne freenext

        lda (tmp2),y            ; desc->next=next->next
        sta (tmp1),y
        dey
        lda (tmp2),y
        sta (tmp1),y

        lda _nheapdesc          ; nheapdesc-- (16-bit, borrow-correct)
        bne freedeclo           ; low byte != 0 -> no borrow into high
        dec _nheapdesc+1        ; borrow: decrement the high byte first
freedeclo
        dec _nheapdesc          ; decrement the low byte

free3
        sec                     ; nheapbytes-=next->len
        ldy #2
        lda _nheapbytes
        sbc (tmp2),y
        sta _nheapbytes
        iny
        lda _nheapbytes+1
        sbc (tmp2),y
        sta _nheapbytes+1

        rts                     ; return

freenext
        lda tmp2                ; desc=next
        sta tmp1
        lda tmp2+1
        sta tmp1+1

        jmp freeloop



;Implementation in C:
;
;void myfree(void *p)
;{
;     register memdesc *wanted=(memdesc *)((char *)p-heapovh);   /* tmp0 */
;     register memdesc *desc=(memdesc *)&heapdesc;               /* tmp1 */
;     register memdesc *next;                                    /* tmp2 */
;
;     if(!p)return;
;
;     while(desc){
;          next=desc->next;
;          if(wanted==next){
;               desc->next=next->next;
;
;               nheapdesc--;
;               nheapbytes-=next->len;
;
;               return;
;          }
;          desc=next;
;     }
;}

