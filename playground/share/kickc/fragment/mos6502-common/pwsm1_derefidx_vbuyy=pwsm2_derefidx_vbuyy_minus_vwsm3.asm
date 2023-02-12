lda {m1}
sta $fe
lda {m1}+1
sta $ff
lda {m2}
sta $fc
lda {m2}+1
sta $fd
sec
lda ($fc),y
sbc {m3}
sta ($fe),y
iny
lda ($fc),y
sbc {m3}+1
sta ($fe),y