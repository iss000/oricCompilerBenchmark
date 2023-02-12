lda {m1}
sta $fe
lda {m1}+1
sta $ff
lda ($fe),y
cmp #<{c1}
iny
lda ($fe),y
sbc #>{c1}
bvc !+
eor #$80
!:
bmi {la1}