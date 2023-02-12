tsx
lda {m1}
sta STACK_BASE+{c1},x
lda {m1}+1
sta STACK_BASE+{c1}+1,x
lda {m1}+2
sta STACK_BASE+{c1}+2,x
lda {m1}+3
sta STACK_BASE+{c1}+3,x