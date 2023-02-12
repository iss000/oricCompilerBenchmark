lda ({z1}),y
clc
adc {c1},x
sta ({z1}),y
iny
lda ({z1}),y
adc {c1}+1,x
sta ({z1}),y
