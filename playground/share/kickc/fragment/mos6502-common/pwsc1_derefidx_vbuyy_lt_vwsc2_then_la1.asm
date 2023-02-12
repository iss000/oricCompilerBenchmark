lda {c1},y
cmp #<{c2}
lda {c1}+1,y
sbc #>{c2}
bvc !+
eor #$80
!:
bmi {la1}