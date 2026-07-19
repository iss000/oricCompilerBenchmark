ldy #1
lda ({z2}),y
lsr
sta {m1}+1
dey
lda ({z2}),y
ror
sta {m1}
lsr {m1}+1
ror {m1}
lsr {m1}+1
ror {m1}