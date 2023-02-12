clc
lda {c1},x
adc {c2},x
sta {c1},x
lda {c1}+1,x
adc {c2}+1,x
sta {c1}+1,x