lda #<{c2}
cmp {c1},x
lda #>{c2}
sbc {c1}+1,x
bvc !+
eor #$80
!:
bmi {la1}