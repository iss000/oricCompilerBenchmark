ldy #0
ldx #3
!:
lda ({z1}),y
asl
sta ({z1}),y
iny
lda ({z1}),y
rol
sta ({z1}),y
dey
dex
bne !-