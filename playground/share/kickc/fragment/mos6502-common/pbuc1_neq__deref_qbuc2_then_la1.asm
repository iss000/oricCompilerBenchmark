lda #<{c1}
cmp {c2}
bne {la1}
lda #>{c1}
cmp {c2}+1
bne {la1}
