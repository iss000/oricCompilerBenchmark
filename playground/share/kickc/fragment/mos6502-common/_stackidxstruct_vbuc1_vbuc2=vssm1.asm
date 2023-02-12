tsx
ldy #0
!:
lda {m1},y
sta STACK_BASE+{c2},x
inx
iny
cpy #{c1}
bne !-