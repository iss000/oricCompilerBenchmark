ldy #0
lda ({z1}),y
cmp {m2}
bne {la1}
iny
lda ({z1}),y
cmp {m2}+1
bne {la1}