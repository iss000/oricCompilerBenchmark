ldy #0
lda ({z2}),y
sec
sbc ({z3}),y
sta {m1}
iny
lda ({z2}),y
sbc ({z3}),y
sta {m1}+1
