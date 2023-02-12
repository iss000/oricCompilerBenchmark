lda ({z2}),y
sta {m1}
iny
lda ({z2}),y
sta {m1}+1
cpx #0
beq !e+
!:
lda {m1}+1
cmp #$80
ror {m1}+1
ror {m1}
dex
bne !-
!e:
