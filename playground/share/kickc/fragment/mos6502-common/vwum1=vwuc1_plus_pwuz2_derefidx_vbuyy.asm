clc
lda #<{c1}
adc ({z2}),y
sta {m1}
iny
lda #>{c1}
adc ({z2}),y
sta {m1}+1
