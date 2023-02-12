ldy #0
clc
lda {c1},x
adc ({z1}),y
pha
iny
lda {c1}+1,x
adc ({z1}),y
sta {z1}+1
pla
sta {z1}

