ldx #0
!:
lda {c2},y
sta {c1},x
iny
inx
cpx #{c3}
bne !-
