lda {m1}+1
bne {la1}
sty $ff
lda {m1}
cmp $ff
bcs {la1}
!: