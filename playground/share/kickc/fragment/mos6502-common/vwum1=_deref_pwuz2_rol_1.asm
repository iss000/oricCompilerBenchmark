ldy #0
lda ({z2}),y
asl
sta {m1}
iny
lda ({z2}),y
rol
sta {m1}+1
