
sec
ldy #{c1}
lda ({z1}),y
sbc {m2}
sta ({z1}),y
ldy #{c1}+1
lda ({z1}),y
sbc {m2}+1
sta ({z1}),y
