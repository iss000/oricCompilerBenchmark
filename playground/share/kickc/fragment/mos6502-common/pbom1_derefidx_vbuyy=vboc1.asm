lda {m1}
sta $fe
lda {m1}+1
sta $ff
lda #{c1}
sta ($fe),y