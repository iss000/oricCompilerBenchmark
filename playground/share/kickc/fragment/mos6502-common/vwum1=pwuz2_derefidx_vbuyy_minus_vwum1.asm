sec
lda ({z2}),y
sbc {m1}
sta {m1}
iny
lda ({z2}),y
sbc {m1}+1
sta {m1}+1