ldy #0
lda ({z2}),y
sec
sbc {m3}
sta ({z1}),y
iny
lda ({z2}),y
sbc {m3}+1
sta ({z1}),y
