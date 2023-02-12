lda {m1}+1
cmp {c1}+1
bcc !+
bne {la1}
lda {m1}
cmp {c1}
bcs {la1}
!:
