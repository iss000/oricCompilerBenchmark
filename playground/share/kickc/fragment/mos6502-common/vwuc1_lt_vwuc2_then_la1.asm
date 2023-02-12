lda #>{c1}
cmp #>{c2}
bcc {la1}
bne !+
lda #<{c1}
cmp #<{c2}
bcc {la1}
!:
