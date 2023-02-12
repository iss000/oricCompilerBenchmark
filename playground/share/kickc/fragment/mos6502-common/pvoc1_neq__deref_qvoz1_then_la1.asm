ldy #0
lda #<{c1}
cmp ({z1}),y
bne {la1}
iny
lda #>{c1}
cmp ({z1}),y
bne {la1}
