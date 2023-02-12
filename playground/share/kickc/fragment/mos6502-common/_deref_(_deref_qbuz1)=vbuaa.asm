pha
ldy #1
lda ({z1}),y
sta $ff
dey
lda ({z1}),y
sta $fe
pla
sta ($fe),y