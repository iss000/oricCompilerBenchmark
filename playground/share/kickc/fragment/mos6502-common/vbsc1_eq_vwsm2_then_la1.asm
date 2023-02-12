lda #<{c1}
cmp {m2}
bne !+
lda #>{c1}
cmp {m2}+1
beq {la1}
!: