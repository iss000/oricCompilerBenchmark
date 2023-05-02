lda #>{c1}>>$10
cmp {m1}+3
bcc {la1}
bne !+
lda #<{c1}>>$10
cmp {m1}+2
bcc {la1}
bne !+
lda #>{c1}
cmp {m1}+1
bcc {la1}
bne !+
lda #<{c1}
cmp {m1}
bcc {la1}
!:
