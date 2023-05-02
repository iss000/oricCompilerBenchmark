lda {m1}
sta $fe
lda {m1}+1
sta $ff
lda {m2}
sta ($fe),y
iny
lda {m2}+1
sta ($fe),y
