clc
lda {m1}
adc ({z2}),y
sta {m1}
iny
lda {m1}+1
adc ({z2}),y
sta {m1}+1
