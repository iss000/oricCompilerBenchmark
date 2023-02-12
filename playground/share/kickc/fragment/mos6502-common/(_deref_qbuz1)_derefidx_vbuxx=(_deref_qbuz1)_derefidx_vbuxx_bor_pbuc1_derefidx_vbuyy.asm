sty $fd
ldy #0
lda ({z1}),y
sta $fe
iny
lda ({z1}),y
sta $ff
txa
tay
ldx $fd
lda ($fe),y
ora {c1},x
sta ($fe),y