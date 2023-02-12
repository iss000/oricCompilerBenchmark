pha
lda ({z1}),y
sta $fe
iny
lda ({z1}),y
sta $ff
pla
ldy #0
sta ($fe),y
