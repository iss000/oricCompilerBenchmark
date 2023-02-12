lda {m1}
sta $fe
lda {m1}+1
sta $ff
lda #<{c2}
sta ($fe),y
iny
lda #>{c2}
sta ($fe),y