lda {m1}
sta $fe
lda {m1}+1
sta $ff
lda ($fe),y
clc
adc #1
sta ($fe),y