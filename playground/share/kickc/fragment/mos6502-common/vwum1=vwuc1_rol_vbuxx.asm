lda #<{c1}
sta {m1}
lda #>{c1}+1
sta {m1}+1
cpx #0
beq !e+
!:
asl {m1}
rol {m1}+1
dex
bne !-
!e:
