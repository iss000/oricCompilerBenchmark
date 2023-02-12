ldy #0
clc
adc ({z1}),y
pha
tya
iny
adc ({z1}),y
sta {z1}+1
pla
sta {z1}