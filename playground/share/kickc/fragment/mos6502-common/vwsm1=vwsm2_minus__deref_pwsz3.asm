sec
lda {m2}
ldy #0
sbc ({z3}),y
sta {m1}
lda {m2}+1
iny
sbc ({z3}),y
sta {m1}+1
