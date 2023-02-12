ldy #0
lda ({z2}),y
cmp ({z1}),y
iny
lda ({z2}),y
sbc ({z1}),y
bvc !+
eor #$80
!:
bmi {la1}