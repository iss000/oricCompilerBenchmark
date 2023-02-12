lda {c1},x
cmp {m1}
lda {c1}+1,x
sbc {m1}+1
bvc !+
eor #$80
!:
bpl {la1}
