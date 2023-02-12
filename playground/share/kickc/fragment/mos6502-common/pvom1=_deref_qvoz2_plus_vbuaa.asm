clc
ldy #0
adc ({z2}),y
sta {m1}
tya
iny
adc ({z2}),y
sta {m1}+1