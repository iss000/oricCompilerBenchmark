clc
lda ({z2}),y
adc {c2},x
sta {m1}
iny
lda ({z2}),y
adc {c2}+1,x
sta {m1}+1

