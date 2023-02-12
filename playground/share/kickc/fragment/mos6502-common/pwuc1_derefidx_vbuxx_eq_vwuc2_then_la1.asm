lda {c1},x
cmp #<{c2}
bne !+
lda {c1}+1,x
cmp #>{c2}
beq {la1}
!: