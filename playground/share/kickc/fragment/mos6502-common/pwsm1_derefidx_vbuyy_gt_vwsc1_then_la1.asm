lda {m1}
sta $fe
lda {m1}+1
sta $ff
lda #<{c1}
cmp ($fe),y
iny
lda #>{c1}
sbc ($fe),y
bvc !+
eor #$80
!:
bmi {la1}