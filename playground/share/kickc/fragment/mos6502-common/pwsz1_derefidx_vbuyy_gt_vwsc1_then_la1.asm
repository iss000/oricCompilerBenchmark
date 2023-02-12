lda #<{c1}
cmp ({z1}),y
iny
lda #>{c1}
sbc ({z1}),y
bvc !+
eor #$80
!:
bmi {la1}
