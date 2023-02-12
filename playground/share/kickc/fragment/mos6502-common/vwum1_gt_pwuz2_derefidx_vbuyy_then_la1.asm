iny
lda ({z2}),y
cmp {m1}+1
bcc {la1}
bne !+
dey
lda ({z2}),y
cmp {m1}
bcc {la1}
!:
