lda {c1},y
sta $fe
lda {c1}+1,y
sta $ff
ldy #0
lda ($fe),y
bne !+
iny
lda ($fe),y
beq {la1}
!: