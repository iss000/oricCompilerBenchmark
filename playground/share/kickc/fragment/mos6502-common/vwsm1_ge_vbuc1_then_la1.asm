lda {m1}
cmp #{c1}
lda {m1}+1
sbc #0
bvc !+
eor #$80
!:
bpl {la1}
