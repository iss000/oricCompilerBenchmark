lda {z1}
cmp {c1},x
bne !+
lda {z1}+1
cmp {c1}+1,x
beq {la1}
!:
