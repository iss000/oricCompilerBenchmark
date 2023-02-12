lda {m1}+1
cmp {c1}+1,x
bcc {la1}
bne !+
lda {m1}
cmp {c1},x
bcc {la1}
!:
