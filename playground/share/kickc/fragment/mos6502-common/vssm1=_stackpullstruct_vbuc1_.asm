ldx #0
!:
pla
sta {m1},x
inx
cpx #{c1}
bne !-