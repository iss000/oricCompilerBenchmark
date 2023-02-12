clc
adc {c1},x
sta {m1}
lda {c1}+1,x
adc #0
sta {m1}+1