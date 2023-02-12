lda {m1}
clc
adc {c1},y
sta {c1},y
lda {m1}+1
adc {c1}+1,y
sta {c1}+1,y
