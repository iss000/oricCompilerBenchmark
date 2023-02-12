lda {m1}
clc
adc ({z2}),y
sta {m1}
iny
lda {m1}+1
adc ({z2}),y
sta {m1}+1
iny
lda {m1}+2
adc ({z2}),y
sta {m1}+2
iny
lda {m1}+3
adc ({z2}),y
sta {m1}+3