ldy #0
lda ({z1}),y
sec
sbc #1
sta ({z1}),y
iny
lda ({z1}),y
sbc #0
sta ({z1}),y
