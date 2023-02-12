lda {c1},x
cmp #<{c2}
lda {c1}+1,x
sbc #>{c2}
bvc !+
eor #$80
!:
bmi {la1}