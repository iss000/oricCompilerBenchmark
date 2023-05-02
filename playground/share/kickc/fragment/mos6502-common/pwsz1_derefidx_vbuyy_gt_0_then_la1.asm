iny
lda ({z1}),y
bne !+
dey
lda ({z1}),y
beq !e+
lsr
!:
bpl {la1}
!e:
