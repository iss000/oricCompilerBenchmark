ldy #{c1}
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
lda #0
sta {z1}+2
sta {z1}+3
