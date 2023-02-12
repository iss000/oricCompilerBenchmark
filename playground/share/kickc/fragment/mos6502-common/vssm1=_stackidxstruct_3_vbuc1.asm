tsx
lda STACK_BASE+{c1},x
sta {m1}
lda STACK_BASE+{c1}+1,x
sta {m1}+1
lda STACK_BASE+{c1}+2,x
sta {m1}+2