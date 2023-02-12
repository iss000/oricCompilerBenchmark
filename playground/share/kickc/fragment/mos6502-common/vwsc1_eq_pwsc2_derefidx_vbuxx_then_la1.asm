lda #>{c1}
cmp {c2}+1,x
bne !+
lda #<{c1}
cmp {c2},x
beq {la1}
!: