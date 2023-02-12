ldy {m1}
sty $fe
ldy {m1}+1
sty $ff
ldy #0
lda ($fe),y
clc
adc #1
sta ($fe),y