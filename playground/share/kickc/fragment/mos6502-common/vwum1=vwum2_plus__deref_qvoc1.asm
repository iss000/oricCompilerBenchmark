clc
lda {m2}
adc {c1}
sta {m1}
lda {m2}+1
adc {c1}+1
sta {m1}+1
