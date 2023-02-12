lda {m1}
sta $fe
lda {m1}+1
sta $ff
sec
lda ($fe),y
sbc #<{c1}
sta ($fe),y
iny
lda ($fe),y
sbc #>{c1}
sta ($fe),y
iny
lda ($fe),y
sbc #<{c1}>>$10
sta ($fe),y
iny
lda ($fe),y
sbc #>{c1}>>$10
sta ($fe),y