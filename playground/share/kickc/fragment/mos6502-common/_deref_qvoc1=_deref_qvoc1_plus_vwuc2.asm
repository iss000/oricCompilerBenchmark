clc
lda {c1}
adc #<{c2}
sta {c1}
lda {c1}+1
adc #>{c2}
sta {c1}+1
