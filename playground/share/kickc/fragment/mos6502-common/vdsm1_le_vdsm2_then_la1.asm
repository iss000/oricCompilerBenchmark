lda {m1}
cmp {m2}
lda {m1}+1
sbc {m2}+1
lda {m1}+2
sbc {m2}+2
lda {m1}+3
sbc {m2}+3
bvc !+
eor #$80
bmi {la1}
!: