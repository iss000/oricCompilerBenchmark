ldy #0
clc
lda ({z1}),y
adc {m2}
pha
iny
lda ({z1}),y
adc {m2}+1
sta {z1}+1
pla
sta {z1}