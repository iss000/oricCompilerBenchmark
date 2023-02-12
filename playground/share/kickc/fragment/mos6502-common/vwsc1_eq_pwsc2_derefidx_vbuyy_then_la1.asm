lda #>{c1}
cmp {c2}+1,y
bne !+
lda #<{c1}
cmp {c2},y
beq {la1}
!: