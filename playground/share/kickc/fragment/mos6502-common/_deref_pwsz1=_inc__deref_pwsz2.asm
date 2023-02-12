ldy #0
clc
lda ({z2}),y
adc #1
sta ({z1}),y
iny
lda ({z2}),y
adc #0
sta ({z1}),y

