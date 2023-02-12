tax
lda #{c1}
cpx #0
beq !e+
!:
asl
dex
bne !-
!e: