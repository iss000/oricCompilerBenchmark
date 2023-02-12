clc
lda #<{c1}
adc {m1}
sta {m1}
lda #>{c1}
adc {m1}+1
sta {m1}+1 
