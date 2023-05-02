ldy {m1}
lda {c1},y
clc
adc {m2}
sta {c1},y
lda {c1}+1,y
adc {m2}+1
sta {c1}+1,y
