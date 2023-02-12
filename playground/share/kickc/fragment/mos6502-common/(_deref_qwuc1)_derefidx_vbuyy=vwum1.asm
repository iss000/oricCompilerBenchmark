lda {c1}
sta $fe
lda {c1}+1
sta $ff
lda m1
sta ($fe),y
iny
lda m1+1
sta ($fe),y
