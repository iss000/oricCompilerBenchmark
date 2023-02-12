lda {m1}+3
cmp {m2}+3
bcc !+
bne {la1}
lda {m1}+2
cmp {m2}+2
bcc !+
bne {la1}
lda {m1}+1
cmp {m2}+1
bcc !+
bne {la1}
lda {m1}
cmp {m2}
bcs {la1}
!:
