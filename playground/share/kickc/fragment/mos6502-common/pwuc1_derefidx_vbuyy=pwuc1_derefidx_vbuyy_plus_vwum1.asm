lda {c1},y
clc
adc {m1}
sta {c1},y
lda {c1}+1,y
adc {m1}+1
sta {c1}+1,y
