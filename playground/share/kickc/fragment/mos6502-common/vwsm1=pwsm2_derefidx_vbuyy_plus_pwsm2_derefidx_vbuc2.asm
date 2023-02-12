lda {m2}
sta $fe
lda {m2}+1
sta $ff
clc
iny
lda ($fe),y
pha
dey
lda ($fe),y
ldy #{c2}
adc ($fe),y
sta {m1}
iny
pla
adc ($fe),y
sta {m1}+1