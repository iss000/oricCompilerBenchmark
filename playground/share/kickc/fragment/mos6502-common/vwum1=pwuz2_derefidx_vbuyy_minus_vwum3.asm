sec
lda ({z2}),y
sbc {m3}
sta {m1}
iny
lda ({z2}),y
sbc {m3}+1
sta {m1}+1