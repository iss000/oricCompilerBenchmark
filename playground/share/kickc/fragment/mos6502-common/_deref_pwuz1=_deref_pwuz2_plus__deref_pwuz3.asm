ldy #0
lda ({z2}),y
clc
adc ({z3}),y
sta ({z1}),y
iny
lda ({z2}),y
adc ({z3}),y
sta ({z1}),y