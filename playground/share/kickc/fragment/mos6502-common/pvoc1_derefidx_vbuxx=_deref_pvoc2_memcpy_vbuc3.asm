ldy #0
!:
lda {c2},y
sta {c1},x
inx
iny
cpy #{c3}
bne !-