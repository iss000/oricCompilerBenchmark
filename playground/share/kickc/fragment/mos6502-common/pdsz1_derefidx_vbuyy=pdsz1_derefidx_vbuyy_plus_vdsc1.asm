clc
lda ({z1}),y
adc #<{c1}
sta ({z1}),y
iny
lda ({z1}),y
adc #>{c1}
sta ({z1}),y
iny
lda ({z1}),y
adc #<{c1}>>$10
sta ({z1}),y
iny
lda ({z1}),y
adc #>{c1}>>$10
sta ({z1}),y