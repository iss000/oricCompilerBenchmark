ldy #0
!:
lda ({z1}),y
sta {c1},y
iny
dex
bne !-