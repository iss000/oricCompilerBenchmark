clc
lda {c1}
adc #<{c2}
sta {m1}
lda {c1}+1
adc #>{c2}
sta {m1}+1
