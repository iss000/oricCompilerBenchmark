lda #{c1}
tay
clc
lda ({z2}),y
adc #<{c2}
sta {z1}
iny
lda ({z2}),y
adc #>{c2}
sta {z1}+1

