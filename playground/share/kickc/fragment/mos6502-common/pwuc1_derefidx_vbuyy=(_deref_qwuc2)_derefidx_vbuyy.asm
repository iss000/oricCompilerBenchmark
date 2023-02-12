lda {c2}
sta $fe
lda {c2}+1
sta $ff
lda ($fe),y
sta {c1},y
iny
lda ($fe),y
sta {c1},y
