sty $ff
lda ({z1}),y
ldy #0
clc
adc ({z1}),y
sta ({z1}),y
ldy $ff
iny
lda ({z1}),y
ldy #1
adc ({z1}),y
sta ({z1}),y
