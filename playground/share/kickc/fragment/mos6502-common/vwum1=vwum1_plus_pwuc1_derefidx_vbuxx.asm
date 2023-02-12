lda {m1}
clc
adc {c1},x
sta {m1}
lda {m1}+1
adc {c1}+1,x
sta {m1}+1
