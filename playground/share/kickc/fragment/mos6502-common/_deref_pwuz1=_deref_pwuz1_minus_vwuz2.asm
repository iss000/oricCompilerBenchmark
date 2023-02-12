ldy #0
lda ({z1}),y
sec
sbc {z2}
sta ({z1}),y
iny
lda ({z1}),y
sbc {z2}+1
sta ({z1}),y