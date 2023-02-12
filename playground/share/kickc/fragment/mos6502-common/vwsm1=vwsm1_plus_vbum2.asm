lda {m1}
clc
adc {m2}
sta {m1}
lda {m1}+1
adc #0
sta {m1}+1
