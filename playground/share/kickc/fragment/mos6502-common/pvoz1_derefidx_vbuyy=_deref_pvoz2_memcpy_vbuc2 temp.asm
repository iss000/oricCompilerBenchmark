ldx #0
!:
lda {c1},x
sta ({z1}),y
iny
inx
cpx #{c2}
bne !-
