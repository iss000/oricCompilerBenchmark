lda #<{c1}
sta {m1}
lda #>{c1}+1
sta {m1}+1
cpy #0
beq !e+
!:
asl {m1}
rol {m1}+1
dey
bne !-
!e:
