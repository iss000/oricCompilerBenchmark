lda ({z1}),y
cmp {m2}
bne !+
iny
lda ({z1}),y
cmp {m2}+1
beq {la1}
!:
