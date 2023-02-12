lda ({z1}),y
sta $fe
iny
lda ({z1}),y
sta $ff
stx $fe
ldy $fe
lda ($fe),y
bne {la1}