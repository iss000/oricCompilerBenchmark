lda {c1},x
clc
adc {c2},y
sta {z1}
lda {c1}+1,x
adc {c2}+1,y
sta {z1}+1