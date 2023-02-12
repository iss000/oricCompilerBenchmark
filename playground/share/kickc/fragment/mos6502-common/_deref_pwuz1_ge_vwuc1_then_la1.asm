ldy #1
lda ({z1}),y
cmp #>{c1}
bcc !+
bne {la1}
dey
lda ({z1}),y
cmp #<{c1}
bcs {la1}
!:
