clc
lda {m1}
adc #1
sta {m2}
lda {m1}+1
adc #0
sta {m2}+1
lda {m1}+2
adc #0
sta {m2}+2
lda {m1}+3
adc #0
sta {m2}+3