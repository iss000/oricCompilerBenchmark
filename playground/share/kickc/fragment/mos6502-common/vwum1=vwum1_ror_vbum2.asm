ldy {m2}
beq !e+
!:
lsr {m1}
ror {m1}+1
dey
bne !-
!e:
