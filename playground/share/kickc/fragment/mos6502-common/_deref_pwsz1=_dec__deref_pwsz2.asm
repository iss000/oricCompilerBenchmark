ldy #0
sec
lda ({z2}),y
sbc #1
sta ({z1}),y
iny
lda ({z2}),y
sbc #0
sta ({z1}),y

