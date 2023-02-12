iny
lda ({z1}),y
pha
dey
clc
lda ({z1}),y
ldy #{c1}
adc ({z2}),y
sta {z1}
pla
iny
adc ({z2}),y
sta {z1}+1
