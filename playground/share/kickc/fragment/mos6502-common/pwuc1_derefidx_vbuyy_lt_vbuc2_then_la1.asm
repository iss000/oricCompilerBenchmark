lda {c1}+1,y
bne !+
lda {c1},y
cmp #{c2}
bcc {la1}
!:
