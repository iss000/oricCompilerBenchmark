lda {m1}+3
cmp #>{c1}>>$10
bcc {la1}
bne !+
lda {m1}+2
cmp #<{c1}>>$10
bcc {la1}
bne !+
lda {m1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {m1}
cmp #<{c1}
bcc {la1}
!:
