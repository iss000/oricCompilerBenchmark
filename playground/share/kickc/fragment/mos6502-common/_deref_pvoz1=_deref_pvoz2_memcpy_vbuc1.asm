ldy #00
!:
lda ({z2}),y
sta ({z1}),y
iny
cpy #{c1}
bne !-