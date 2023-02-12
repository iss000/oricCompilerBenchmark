lda {m1}
sta $fe
lda {m1}+1
sta $ff
lda ($fe),y
sta {m1}
iny
lda ($fe),y
sta {m1}+1
