lda {m1}+1
bne !+
sty $ff
lda {m1}
cmp $ff
bcc {la1}
!:
