ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
clc
adc ($fe),y
sta ($fe),y