lda #>{c1}
cmp {m1}+1
bcc {la1}
bne !+
lda #<{c1}
cmp {m1}
bcc {la1}
!:
