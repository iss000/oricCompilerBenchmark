lda {m1}+1
bne !+
lda {m1}
beq !e+
lsr
!:
bpl {la1}
!e:
