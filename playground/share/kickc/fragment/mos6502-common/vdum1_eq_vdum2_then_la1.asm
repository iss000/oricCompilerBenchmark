lda {m1}
cmp {m2}
bne !+
lda {m1}+1
cmp {m2}+1
bne !+
lda {m1}+2
cmp {m2}+2
bne !+
lda {m1}+3
cmp {m2}+3
beq {la1}
!:
