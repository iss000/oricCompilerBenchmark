ldy {z1}
lda {c1},y
clc
adc {z2}
sta {c1},y
lda {c1}+1,y
adc {z2}+1
sta {c1}+1,y