sta {m1}
lda #0
sta {m1}+1
cpy #0
beq !e+
!:
asl {m1}
rol {m1}+1
dey
bne !-
!e: