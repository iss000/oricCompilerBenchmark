sec
lda ({z1}),y
sbc #<{c2}
pha
iny
lda ({z1}),y
sbc #>{c2}
sta {z1}+1
pla
sta {z1}