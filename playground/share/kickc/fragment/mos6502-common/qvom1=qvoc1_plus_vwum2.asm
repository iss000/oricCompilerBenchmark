lda #<{c1}
clc
adc {m2}
sta {m1}
lda #>{c1}
adc {m2}+1
sta {m1}+1