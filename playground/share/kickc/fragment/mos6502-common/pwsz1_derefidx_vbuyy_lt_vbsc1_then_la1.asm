lda ({z1}),y
cmp #<{c1}
iny
lda ({z1}),y
sbc #>{c1}
bvc !+
eor #$80
!:
bmi {la1}