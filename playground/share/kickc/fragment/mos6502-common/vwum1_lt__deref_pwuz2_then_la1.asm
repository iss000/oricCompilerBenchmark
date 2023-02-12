ldy #1
lda {m1}+1
cmp ({z2}),y
bcc {la1}
bne !+
dey
lda {m1}
cmp ({z2}),y
bcc {la1}
!:
