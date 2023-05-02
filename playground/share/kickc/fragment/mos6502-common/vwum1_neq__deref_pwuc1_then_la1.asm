ldy #1
lda {m1}+1
cmp {c1}+1
bne {la1}
dey
lda {m1}
cmp {c1}
bne {la1}