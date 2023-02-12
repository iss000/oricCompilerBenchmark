sty $ff
lda ({z2}),y
ldy #0
cmp ({z1}),y
bne {la1}
iny
lda ({z1}),y
ldy $ff
iny
cmp ({z2}),y
bne {la1}