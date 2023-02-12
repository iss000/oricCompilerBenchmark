lda {m1}
clc
adc {m2}
sta {m1}
lda {m1}+1
adc {m2}+1
sta {m1}+1
lda {m1}+2
adc #0
sta {m1}+2
lda {m1}+3
adc #0
sta {m1}+3

