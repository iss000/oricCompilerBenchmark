ldy #0
lda ({z2}),y
clc
adc #<{c1}
sta ({z1}),y
iny
lda ({z2}),y
adc #>{c1}
sta ({z1}),y