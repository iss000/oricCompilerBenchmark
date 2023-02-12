ldy #1
lda ({z1}),y
bne !+
dey
lda ({z1}),y
cmp #{c1}
beq {la1}
!:
