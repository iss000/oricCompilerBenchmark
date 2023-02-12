tsx
ldy #0
!:
lda STACK_BASE+{c2},x
sta {m1},y
inx
iny
cpy #{c1}
bne !-