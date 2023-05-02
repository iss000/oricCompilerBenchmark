lda {z1}
cmp {c1},y
bne !+
lda {z1}+1
cmp {c1}+1,y
beq {la1}
!:
