lda {c1}+1,y
cmp {m1}+1
bcc {la1}
bne !+
lda {c1},y
cmp {m1}
bcc {la1}
!:
