ldy #1
lda ({z2}),y
cmp #$80
ror
sta {m1}+1
dey
lda ({z2}),y
ror
sta {m1}
lda {m1}+1
cmp #$80
ror {m1}+1
ror {m1}
