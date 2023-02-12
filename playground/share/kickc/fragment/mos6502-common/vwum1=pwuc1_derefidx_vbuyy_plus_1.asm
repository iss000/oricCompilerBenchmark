lda {c1},y
clc
adc #1
sta {m1}
lda {c1}+1,y
adc #0
sta {m1}+1

