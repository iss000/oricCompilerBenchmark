lda {c1}+1,x
cmp #>{c2}
bne {la1}
lda {c1},x
cmp #<{c2}
bne {la1}
