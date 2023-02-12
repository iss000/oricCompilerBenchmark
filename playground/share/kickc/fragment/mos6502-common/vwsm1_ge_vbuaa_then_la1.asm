sta $ff
lda {m1}
cmp $ff
lda {m1}+1
sbc #0
bvc !+
eor #$80
!:
bpl {la1}
