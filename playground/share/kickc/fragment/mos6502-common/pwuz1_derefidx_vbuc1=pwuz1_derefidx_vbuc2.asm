ldy #{c2}
lda ({z1}),y
ldy #{c1}
sta ({z1}),y
ldy #{c2}+1
lda ({z1}),y
ldy #{c1}+1
sta ({z1}),y
