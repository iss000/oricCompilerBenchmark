lda {m1}
sta $fe
lda {m1}+1
sta $ff
clc
lda ($fe),y
adc {m2}
sta ($fe),y
iny
lda ($fe),y
adc {m2}+1
sta ($fe),y