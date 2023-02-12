iny
lda ({z1}),y
cmp #>{c1}
bcc {la1}
bne !+
dey
lda ({z1}),y
cmp #<{c1}
bcc {la1}
!:
