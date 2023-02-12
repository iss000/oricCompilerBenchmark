clc
lda {c1},y
adc #{c2}
sta {c1},x
lda {c1}+1,y
adc #0
sta {c1}+1,x