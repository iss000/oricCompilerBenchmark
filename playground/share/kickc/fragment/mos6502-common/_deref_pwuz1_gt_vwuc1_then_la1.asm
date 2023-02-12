ldy #1
lda #>{c1}
cmp ({z1}),y
bcc {la1}
bne !+
dey
lda #<{c1}
cmp ({z1}),y
bcc {la1}
!:
