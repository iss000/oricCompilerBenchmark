ldy #0
sty {m1}+2
sty {m1}+3
lda ({z2}),y
sta {m1}
iny
lda ({z2}),y
sta {m1}+1