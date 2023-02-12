lda {m1}
sta $fc
lda {m1}+1
sta $fd
lda {m2}
sta $fe
lda {m2}+1
sta $ff
sec
lda ($fe),y
sbc {m3}
sta ($fc),y
iny
lda ($fe),y
sbc {m3}+1
sta ($fc),y
iny
lda ($fe),y
sbc {m3}+2
sta ($fc),y
iny
lda ($fe),y
sbc {m3}+3
sta ($fc),y