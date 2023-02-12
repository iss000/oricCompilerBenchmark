lda ({z1}),y
sta $fe
iny
lda ({z1}),y
sta $ff
ldy #{c2}
lda ({z1}),y
sta ($fe),y
iny
lda ({z1}),y
sta ($fe),y