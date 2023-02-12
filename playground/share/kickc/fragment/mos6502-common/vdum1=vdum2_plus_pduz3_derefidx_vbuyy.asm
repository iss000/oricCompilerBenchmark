lda {m2}
clc
adc ({z3}),y
sta {m1}
iny
lda {m2}+1
adc ({z3}),y
sta {m1}+1
iny
lda {m2}+2
adc ({z3}),y
sta {m1}+2
iny
lda {m2}+3
adc ({z3}),y
sta {m1}+3