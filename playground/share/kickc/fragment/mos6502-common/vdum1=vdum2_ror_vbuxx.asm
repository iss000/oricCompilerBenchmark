lda {m2}
sta {m1}
lda {m2}+1
sta {m1}+1
lda {m2}+2
sta {m1}+2
lda {m2}+3
sta {m1}+3
cpx #0
beq !e+
!:
lsr {m1}+3
ror {m1}+2
ror {m1}+1
ror {m1}
dex
bne !-
!e:
