clc
lda {m2}
adc #<{c1}
sta {m1}
lda {m2}+1
adc #>{c1}
sta {m1}+1
lda {m2}+2
adc #0
sta {m1}+2
lda {m2}+3
adc #0
sta {m1}+3
