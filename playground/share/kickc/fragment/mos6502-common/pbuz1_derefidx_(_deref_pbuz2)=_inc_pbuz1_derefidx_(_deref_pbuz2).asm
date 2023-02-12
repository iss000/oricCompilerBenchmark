ldy #0
lda ({z2}),y
tay
clc
lda ({z1}),y
adc #1
sta ({z1}),y