sty $ff
lda {m1}+1
bmi {la1}
bne !+
lda {m1}
cmp $ff
bcc {la1}
!:
