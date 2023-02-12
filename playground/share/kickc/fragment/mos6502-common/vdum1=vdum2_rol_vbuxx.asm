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
asl {m1}
rol {m1}+1
rol {m1}+2
rol {m1}+3
dex
bne !-
!e:
