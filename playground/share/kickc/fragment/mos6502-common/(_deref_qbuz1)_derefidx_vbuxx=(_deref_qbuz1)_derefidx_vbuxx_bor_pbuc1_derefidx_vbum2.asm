ldy #0
lda ({z1}),y
sta $fe
iny
lda ({z1}),y
sta $ff
txa
tay
ldx {m2}
lda ($fe),y
ora {c1},x
sta ($fe),y