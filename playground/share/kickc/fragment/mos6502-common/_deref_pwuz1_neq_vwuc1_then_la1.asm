ldy #0
lda ({z1}),y
cmp #<{c1}
bne {la1}
iny
lda ({z1}),y
cmp #>{c1}
bne {la1}