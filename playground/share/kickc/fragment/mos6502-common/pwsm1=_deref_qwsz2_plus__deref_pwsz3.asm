ldy #0
lda ({z2}),y
clc
adc ({z3}),y
sta {m1}
iny
lda ({z2}),y
adc ({z3}),y
sta {m1}+1
