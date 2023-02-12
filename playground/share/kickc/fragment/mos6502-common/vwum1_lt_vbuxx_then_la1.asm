lda {m1}+1
bne !+
stx $ff
lda {m1}
cmp $ff
bcc {la1}
!:
