lda {m2}
sta $fe
lda {m2}+1
sta $ff
ldy #0
lda ($fe),y
sta {m1}
iny
lda ($fe),y
sta {m1}+1