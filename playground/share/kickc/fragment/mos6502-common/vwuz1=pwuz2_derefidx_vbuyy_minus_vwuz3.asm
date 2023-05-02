sec
lda ({z2}),y
sty $ff
ldy #0
sbc ({z3}),y
sta {z1}
ldy $ff
iny
lda ({z2}),y
ldy #1
sbc ({z3}),y
sta {z1}+1
