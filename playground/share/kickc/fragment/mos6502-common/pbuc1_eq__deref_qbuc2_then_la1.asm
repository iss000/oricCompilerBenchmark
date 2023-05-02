lda #<{c1}
cmp {c2}
bne !+
lda #>{c1}
cmp {c2}+1
beq {la1}
!: