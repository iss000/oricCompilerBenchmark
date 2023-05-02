ldy #0
clc
lda ({z1}),y
ora #<{c1}
pha
iny
lda ({z1}),y
ora #>{c1}
sta {z1}+1
pla
sta {z1}
