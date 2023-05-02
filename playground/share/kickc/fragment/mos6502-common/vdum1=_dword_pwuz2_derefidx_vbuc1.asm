ldy #{c1}
lda ({z2}),y
sta {m1}
iny
lda ({z2}),y
sta {m1}+1
lda #0
sta {m1}+2
sta {m1}+3
