sta $ff
lda $0
pha
lda #{c1}
sta $0
lda $ff
jsr {la1}
sta $ff
pla
sta $0
lda $ff