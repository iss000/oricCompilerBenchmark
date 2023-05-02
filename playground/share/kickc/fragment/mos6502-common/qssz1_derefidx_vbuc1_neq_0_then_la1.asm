ldy #<{c1}
lda ({z1}),y
bne {la1}
iny
lda ({z1}),y
bne {la1}
!:
