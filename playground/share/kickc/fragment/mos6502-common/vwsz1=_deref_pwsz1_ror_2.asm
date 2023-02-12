ldy #0
lda ({z1}),y
pha
iny
lda ({z1}),y
cmp #$80
ror
sta {z1}+1
pla
ror
sta {z1}
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
