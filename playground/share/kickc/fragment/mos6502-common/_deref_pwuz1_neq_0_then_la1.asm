ldy #0
lda ({z1}),y
iny
ora ({z1}),y
bne {la1}