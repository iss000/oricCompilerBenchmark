ldy #0
sec
lda ({z2}),y
sbc ({z1}),y
pha
iny
lda ({z2}),y
sbc ({z1}),y
sta {z1}+1
pla
sta {z1}
