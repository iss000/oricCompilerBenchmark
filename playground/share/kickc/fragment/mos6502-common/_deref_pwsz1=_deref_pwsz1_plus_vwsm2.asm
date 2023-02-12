ldy #0
clc
lda ({z1}),y
adc {m2}
sta ({z1}),y
iny
lda ({z1}),y
adc {m2}+1
sta ({z1}),y
