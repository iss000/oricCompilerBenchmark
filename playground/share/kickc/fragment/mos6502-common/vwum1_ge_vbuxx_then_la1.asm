lda {m1}+1
bne {la1}
stx $ff
lda {m1}
cmp $ff
bcs {la1}
!: