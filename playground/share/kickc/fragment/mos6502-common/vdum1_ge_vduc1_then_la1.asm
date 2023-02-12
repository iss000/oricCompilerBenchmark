lda {m1}+3
cmp #>{c1}>>$10
bcc !+
bne {la1}
lda {m1}+2
cmp #<{c1}>>$10
bcc !+
bne {la1}
lda {m1}+1
cmp #>{c1}
bcc !+
bne {la1}
lda {m1}
cmp #<{c1}
bcs {la1}
!:
