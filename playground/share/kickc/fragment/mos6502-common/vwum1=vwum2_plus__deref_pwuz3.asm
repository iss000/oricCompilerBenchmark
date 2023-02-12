ldy #0
clc
lda {m2}
adc ({z3}),y
sta {m1}
iny
lda {m2}+1
adc ({z3}),y
sta {m1}+1