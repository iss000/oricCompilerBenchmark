lda #<{c1}
cmp {c2},y
lda #>{c1}
sbc {c2}+1,y
bvc !+
eor #$80
!:
bmi {la1}