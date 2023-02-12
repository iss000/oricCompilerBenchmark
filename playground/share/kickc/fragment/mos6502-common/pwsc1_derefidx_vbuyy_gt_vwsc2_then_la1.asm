lda #<{c2}
cmp {c1},y
lda #>{c2}
sbc {c1}+1,y
bvc !+
eor #$80
!:
bmi {la1}