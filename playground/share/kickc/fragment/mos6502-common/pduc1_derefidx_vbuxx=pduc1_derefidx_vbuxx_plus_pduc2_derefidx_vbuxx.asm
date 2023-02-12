lda {c1},x
clc
adc {c2},x
sta {c1},x
lda {c1}+1,x
adc {c2}+1,x
sta {c1}+1,x
lda {c1}+2,x
adc {c2}+2,x
sta {c1}+2,x
lda {c1}+3,x
adc {c2}+3,x
sta {c1}+3,x