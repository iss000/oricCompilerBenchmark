lda {c1},y
cmp {m1}
lda {c1}+1,y
sbc {m1}+1
bvc !+
eor #$80
!:
bpl {la1}
