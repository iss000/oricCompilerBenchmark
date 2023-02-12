lda {m1}
sta $fe
lda {m1}+1
sta $ff
sec
lda ($fe),y
sbc {m2}
sta ($fe),y
iny
lda ($fe),y
sbc {m2}+1
sta ($fe),y
iny
lda ($fe),y
sbc {m2}+2
sta ($fe),y
iny
lda ($fe),y
sbc {m2}+3
sta ($fe),y