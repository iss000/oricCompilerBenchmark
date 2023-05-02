ldy #0
lda ({z1}),y
eor #<{c1}
pha
iny
lda ({z1}),y
eor #>{c1}
sta {z1}+1
pla
sta {z1}
