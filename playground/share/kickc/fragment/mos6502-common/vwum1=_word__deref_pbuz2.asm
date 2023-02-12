ldy #0
lda ({z2}),y
sta {m1}
iny
lda #0
sta {m1}+1
