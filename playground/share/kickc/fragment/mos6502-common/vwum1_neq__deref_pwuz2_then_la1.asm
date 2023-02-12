ldy #1
lda {m1}+1
cmp ({z2}),y
bne {la1}
dey
lda {m1}
cmp ({z2}),y
bne {la1}