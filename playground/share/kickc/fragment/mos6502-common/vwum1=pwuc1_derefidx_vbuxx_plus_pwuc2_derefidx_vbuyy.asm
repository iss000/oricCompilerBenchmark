lda {c1},x
clc
adc {c2},y
sta {m1}
lda {c1}+1,x
adc {c2}+1,y
sta {m1}+1
