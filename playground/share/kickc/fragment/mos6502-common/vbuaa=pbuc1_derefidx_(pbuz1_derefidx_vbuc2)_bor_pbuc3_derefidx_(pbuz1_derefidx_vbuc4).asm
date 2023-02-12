ldy #{c2}
lda ({z1}),y
tay
lda {c1},y
sta $ff
ldy #{c4}
lda ({z1}),y
tay
lda {c3},y
ora $ff