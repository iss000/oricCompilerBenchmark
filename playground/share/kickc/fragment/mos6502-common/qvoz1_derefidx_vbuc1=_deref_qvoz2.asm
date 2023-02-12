ldy #1
lda ({z2}),y
pha
dey
lda ({z2}),y
ldy #{c1}
sta ({z1}),y
iny
pla
sta ({z1}),y
