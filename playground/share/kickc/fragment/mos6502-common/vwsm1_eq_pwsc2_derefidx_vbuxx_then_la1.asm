lda {m1}+1
cmp {c1}+1,x
bne !+
lda {m1}
cmp {c1},x
beq {la1}
!:
