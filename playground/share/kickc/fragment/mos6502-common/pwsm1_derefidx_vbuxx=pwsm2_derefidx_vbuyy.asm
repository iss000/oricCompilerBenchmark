lda {m1}
sta $fc
lda {m1}+1
sta $fd
lda {m2}
sta $fe
lda {m2}+1
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
sta ($fc),y
dey
pla
sta ($fc),y