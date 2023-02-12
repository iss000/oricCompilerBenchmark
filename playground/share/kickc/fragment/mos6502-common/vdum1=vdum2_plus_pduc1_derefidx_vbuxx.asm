lda {m2}
clc
adc {c1},x
sta {m1}
lda {m2}+1
adc {c1}+1,x
sta {m1}+1
lda {m2}+2
adc {c1}+2,x
sta {m1}+2
lda {m2}+3
adc {c1}+3,x
sta {m1}+3