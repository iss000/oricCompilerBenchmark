ldy #1
lda ({z1}),y
lsr
pha
dey
lda ({z1}),y
ror
sta {z1}
pla
sta {z1}+1
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
