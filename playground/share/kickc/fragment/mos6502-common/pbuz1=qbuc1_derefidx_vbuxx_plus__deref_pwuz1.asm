ldy #0
lda {c1},x
clc
adc ({z1}),y
pha
iny
lda {c1}+1,x
adc ({z1}),y
sta {z1}+1
pla
sta {z1}