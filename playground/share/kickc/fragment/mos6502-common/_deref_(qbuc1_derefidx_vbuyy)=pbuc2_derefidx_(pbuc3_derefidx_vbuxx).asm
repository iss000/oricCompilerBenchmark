lda {c1},y
sta $fe
lda {c1}+1,y
sta $ff
ldy {c3},x
lda {c2},y
ldy #0
sta ($fe),y