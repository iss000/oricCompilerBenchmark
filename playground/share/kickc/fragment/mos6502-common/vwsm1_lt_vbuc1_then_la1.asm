lda {m1}+1
bmi {la1}
bne !+
lda {m1}
cmp #{c1}
bcc {la1}
!:
