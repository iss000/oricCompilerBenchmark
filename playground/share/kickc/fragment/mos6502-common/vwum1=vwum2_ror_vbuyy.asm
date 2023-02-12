lda {m2}
sta {m1}
lda {m2}+1
sta {m1}+1
cpy #0
beq !e+
!:
lsr {m1}+1
ror {m1}
dey
bne !-
!e:
