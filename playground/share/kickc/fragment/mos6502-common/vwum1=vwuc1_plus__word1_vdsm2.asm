lda #<{c1}
clc
adc {m2}+2
sta {m1}
lda #>{c1}
adc {m2}+3
sta {m1}+1
