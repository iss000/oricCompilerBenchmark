lda {m2}
sta $fe
lda {m2}+1
sta $ff
lda ($fe),y
sta {m1}
lda #0
sta {m1}+1