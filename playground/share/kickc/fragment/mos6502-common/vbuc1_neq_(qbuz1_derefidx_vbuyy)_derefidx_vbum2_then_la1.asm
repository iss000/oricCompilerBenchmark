lda ({z1}),y
sta $fe
iny
lda ({z1}),y
sta $ff
ldy {m2}
lda ($fe),y
cmp #{c1}
bne {la1}
