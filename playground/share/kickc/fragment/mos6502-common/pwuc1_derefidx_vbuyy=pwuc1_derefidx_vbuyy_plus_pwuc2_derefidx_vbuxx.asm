clc
lda {c1},y
adc {c2},x
sta {c1},y
lda {c1}+1,y
adc {c2}+1,x
sta {c1}+1,y