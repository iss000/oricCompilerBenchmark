lda {m2}
cmp {m1}
lda {m2}+1
sbc {m1}+1
bvc !+
eor #$80
!:
bmi {la1}