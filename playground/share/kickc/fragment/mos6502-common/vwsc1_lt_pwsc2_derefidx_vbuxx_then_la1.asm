lda #<{c1}
cmp {c2},x
lda #>{c1}
sbc {c2}+1,x
bvc !+
eor #$80
!:
bmi {la1}