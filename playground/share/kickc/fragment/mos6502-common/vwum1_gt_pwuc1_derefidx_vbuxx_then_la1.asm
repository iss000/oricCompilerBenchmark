lda {c1}+1,x
cmp {m1}+1
bcc {la1}
bne !+
lda {c1},x
cmp {m1}
bcc {la1}
!:
