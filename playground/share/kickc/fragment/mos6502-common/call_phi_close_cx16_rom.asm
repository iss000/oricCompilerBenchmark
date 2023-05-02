sta $ff
lda $1
pha
lda #{c1}
sta $1
lda $ff
jsr {la1}
sta $ff
pla
sta $1
lda $ff