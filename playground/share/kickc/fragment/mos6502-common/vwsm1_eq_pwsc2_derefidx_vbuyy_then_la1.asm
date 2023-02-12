lda {m1}+1
cmp {c1}+1,y
bne !+
lda {m1}
cmp {c1},y
beq {la1}
!:
