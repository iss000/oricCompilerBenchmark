clc
lda {m1}
adc ({z2}),y
sta {m1}
lda {m1}+1
iny
adc ({z2}),y
sta {m1}+1
