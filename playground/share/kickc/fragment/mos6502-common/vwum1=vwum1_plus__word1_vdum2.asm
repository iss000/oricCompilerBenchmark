clc
lda {m1}
adc {m2}+2
sta {m1}
lda {m1}+1
adc {m2}+3
sta {m1}+1
