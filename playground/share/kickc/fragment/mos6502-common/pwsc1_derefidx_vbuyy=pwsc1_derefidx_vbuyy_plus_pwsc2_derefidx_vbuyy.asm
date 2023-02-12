clc
lda {c1},y
adc {c2},y
sta {c1},y
lda {c1}+1,y
adc {c2}+1,y
sta {c1}+1,y