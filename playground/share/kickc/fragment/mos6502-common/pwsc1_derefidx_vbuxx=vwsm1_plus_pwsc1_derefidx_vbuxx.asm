lda {m1}
clc
adc {c1},x
sta {c1},x
lda {m1}+1
adc {c1}+1,x
sta {c1}+1,x
