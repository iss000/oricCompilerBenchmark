clc
lda {c1},x
adc {z1}
sta {c1},x
lda {c1}+1,x
adc {z1}+1
sta {c1}+1,x