ldy #0
clc
lda ({z2}),y
adc {m3}
sta ({z1}),y
iny
lda ({z2}),y
adc {m3}+1
sta ({z1}),y
