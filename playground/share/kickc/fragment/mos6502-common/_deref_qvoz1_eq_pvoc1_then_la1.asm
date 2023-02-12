ldy #0
lda ({z1}),y
cmp #<{c1}
bne !+
iny
lda ({z1}),y
cmp #>{c1}
beq {la1}
!: