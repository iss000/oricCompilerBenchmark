ldy #0
clc
lda ({z2}),y
adc {m1}
sta {m1}
iny
lda ({z2}),y
adc {m1}+1
sta {m1}+1