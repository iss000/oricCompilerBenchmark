sty $ff
ldy #1
lda ({z2}),y
pha
dey
lda ({z2}),y
ldy $ff
sta ({z1}),y
iny
pla
sta ({z1}),y