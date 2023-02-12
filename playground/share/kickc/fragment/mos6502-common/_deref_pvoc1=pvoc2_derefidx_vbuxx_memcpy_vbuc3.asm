ldy #0
!:
lda {c2},x
sta {c1},y
inx
iny
cpy #{c3}
bne !-
