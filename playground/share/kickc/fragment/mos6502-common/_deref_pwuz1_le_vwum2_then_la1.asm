ldy #1
lda ({z1}),y
cmp {m2}+1
bne !+
dey
lda ({z1}),y
cmp {m2}
beq {la1}
!:
bcc {la1}
