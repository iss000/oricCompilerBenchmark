lda {m1}
sta $fe
lda {m1}+1
sta $ff
lda ($fe),y
pha
iny
lda ($fe),y
pha
txa
tay
iny
pla
sta ($fe),y
dey
pla
sta ($fe),y