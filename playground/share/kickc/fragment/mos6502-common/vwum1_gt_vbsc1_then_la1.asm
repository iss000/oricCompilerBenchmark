lda #{c1}
bmi {la1}
cmp {m1}
bcc {la1}
lda {m1}+1
bne {la1}
