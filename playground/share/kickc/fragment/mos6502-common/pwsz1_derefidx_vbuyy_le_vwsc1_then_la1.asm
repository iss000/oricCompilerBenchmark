iny
lda ({z1}),y
cmp #>{c1}
bne !+
dey
lda ({z1}),y
cmp #<{c1}
beq {la1}
!:
bcc {la1}