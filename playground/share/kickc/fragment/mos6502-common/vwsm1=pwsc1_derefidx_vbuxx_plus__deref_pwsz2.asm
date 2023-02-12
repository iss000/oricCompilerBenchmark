ldy #0
lda {c1},x
clc
adc ({z2}),y
sta {m1}
iny
lda {c1}+1,x
adc ({z2}),y
sta {m1}+1

