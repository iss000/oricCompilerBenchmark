lda {c1}+1,y
cmp #>{c2}
bne {la1}
lda {c1},y
cmp #<{c2}
bne {la1}
