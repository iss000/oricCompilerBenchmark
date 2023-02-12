lda {c1}+1,y
cmp {m1}+1
bne !+
lda {c1},y
cmp {m1}
beq {la1}
!:
bcc {la1}
