ldy #0
lda {m2}
sta ({z1}),y
iny
lda {m2}+1
sta ({z1}),y