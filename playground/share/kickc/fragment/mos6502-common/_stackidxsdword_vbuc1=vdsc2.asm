tsx
lda #<{c2}
sta STACK_BASE+{c1},x
lda #>{c2}
sta STACK_BASE+{c1}+1,x
lda #<{c2}>>$10
sta STACK_BASE+{c1}+2,x
lda #>{c2}>>$10
sta STACK_BASE+{c1}+3,x