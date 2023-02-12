lda {c1},y
clc
adc {c2},x
sta {z1}
lda {c1}+1,y
adc {c2}+1,x
sta {z1}+1