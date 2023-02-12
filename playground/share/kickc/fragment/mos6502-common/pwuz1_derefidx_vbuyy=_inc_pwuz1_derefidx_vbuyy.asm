lda ({z1}),y
clc
adc #1
sta ({z1}),y
bne !+
iny
lda ({z1}),y
adc #0
sta ({z1}),y
!: