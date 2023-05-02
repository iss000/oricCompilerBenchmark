sec
lda ({z1}),y
sbc {m2}
pha
iny
lda ({z1}),y
sbc {m2}+1
sta {z1}+1
pla
sta {z1}