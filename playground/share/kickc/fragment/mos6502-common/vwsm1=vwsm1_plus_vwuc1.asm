clc
lda {m1}
adc #<{c1}
sta {m1}
lda {m1}+1
adc #>{c1}
sta {m1}+1
