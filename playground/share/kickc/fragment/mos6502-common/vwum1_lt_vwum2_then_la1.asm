lda {m1}+1
cmp {m2}+1
bcc {la1}
bne !+
lda {m1}
cmp {m2}
bcc {la1}
!:
