ldx #0
!:
lda {c2},x
sta {c1},y
iny
inx
cpx #{c3}
bne !-