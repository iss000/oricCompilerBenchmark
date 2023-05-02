lda {c1},x
clc
adc {m1}
sta {c1},x
lda {c1}+1,x
adc {m1}+1
sta {c1}+1,x
