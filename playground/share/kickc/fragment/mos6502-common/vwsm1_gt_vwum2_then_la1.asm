lda {m1}+1
bmi !+
cmp {m2}+1
bcs {la1}
beq {la1}
lda {m2}
cmp {m1}
bcc {la1}
!: