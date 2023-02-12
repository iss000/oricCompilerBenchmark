lda {c1},y
cmp #<{c2}
bne !+
lda {c1}+1,y
cmp #>{c2}
beq {la1}
!: