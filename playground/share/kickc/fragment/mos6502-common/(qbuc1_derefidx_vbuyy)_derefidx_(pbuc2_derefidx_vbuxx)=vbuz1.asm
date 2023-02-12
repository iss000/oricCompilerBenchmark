lda {c1},y
sta $fe
lda {c1}+1,y
sta $ff
ldy {c2},x
lda {z1}
sta ($fe),y
