ldy #0
clc
lda ({z2}),y
adc ({z3}),y
sta {m1}
iny
lda ({z2}),y
adc ({z3}),y
sta {m1}+1