lda ({z1}),y
and #<{c1}
pha
iny
lda ({z1}),y
and #>{c1}
sta {z1}+1
pla
sta {z1}
