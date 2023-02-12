clc
lda {c1},x
adc {c1},y
sta {m1}
lda {c1}+1,x
adc {c1}+1,y
sta {m1}+1
