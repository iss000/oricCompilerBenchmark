stx $fd
lda ({z1}),y
sta $fe
iny
lda ({z1}),y
sta $ff
ldy $fd
lda ($fe),y