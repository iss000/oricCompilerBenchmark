stx $ff
tax
lda {c1},x
sec
sbc $ff
sta {c1},x
bcs !+
dec {c1}+1,x
!: