ldy {c2}
lda ({z1}),y
sta {c1},x
iny
lda ({z1}),y
sta {c1}+1,x
