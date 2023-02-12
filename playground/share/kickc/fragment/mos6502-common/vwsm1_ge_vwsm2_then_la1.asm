lda {m1}
cmp {m2}
lda {m1}+1
sbc {m2}+1
bvc !+
eor #$80
!:
bpl {la1}
