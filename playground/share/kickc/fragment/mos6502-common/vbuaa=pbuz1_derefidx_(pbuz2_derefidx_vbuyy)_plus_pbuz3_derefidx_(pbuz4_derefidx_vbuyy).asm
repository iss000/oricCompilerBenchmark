lda ({z4}),y
sta $ff
lda ({z2}),y
tay
lda ({z1}),y
ldy $ff
clc
adc ({z3}),y