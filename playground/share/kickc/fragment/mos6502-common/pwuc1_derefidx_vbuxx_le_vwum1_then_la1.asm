lda {c1}+1,x
cmp {m1}+1
bne !+
lda {c1},x
cmp {m1}
beq {la1}
!:
bcc {la1}
