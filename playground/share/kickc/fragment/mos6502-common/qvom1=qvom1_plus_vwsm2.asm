clc
lda {m1}
adc {m2}
sta {m1}
lda {m1}+1
adc {m2}+1
sta {m1}+1
