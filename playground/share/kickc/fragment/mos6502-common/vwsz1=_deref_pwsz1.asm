ldy #0
lda ({z1}),y
pha
iny
lda ({z1}),y
sta {z1}+1
pla
sta {z1}
