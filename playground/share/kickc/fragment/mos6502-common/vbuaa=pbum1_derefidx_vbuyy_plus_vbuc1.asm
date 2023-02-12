lda {m1}
sta $fe
lda {m1}+1
sta $ff
clc
lda ($fe),y
adc #{c1}