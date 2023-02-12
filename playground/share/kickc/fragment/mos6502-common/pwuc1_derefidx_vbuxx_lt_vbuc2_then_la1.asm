lda {c1}+1,x
bne !+
lda {c1},x
cmp #{c2}
bcc {la1}
!:
