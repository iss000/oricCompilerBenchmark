ldy {m1}
sty $fe
ldy {m1}+1
sty $ff
ldy #0
lda {m2}
sta ($fe),y
iny
lda {m2}+1
sta ($fe),y