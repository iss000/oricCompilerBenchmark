clc
lda {c1},y
adc {c2},x
sta {m1}
lda {c1}+1,y
adc {c2}+1,x
sta {m1}+1
