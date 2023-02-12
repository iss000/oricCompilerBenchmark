clc
lda {m1}
adc {m2}
sta {m1}
lda {m1}+1
adc {m2}+1
sta {m1}+1
lda {m1}+2
adc {m2}+2
sta {m1}+2
lda {m1}+3
adc {m2}+3
sta {m1}+3
