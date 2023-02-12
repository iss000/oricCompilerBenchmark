ldy #0
lda ({z2}),y
clc
adc {m3}
sta {m1}
iny
lda ({z2}),y
adc {m3}+1
sta {m1}+1
