ldy {m1}
lda {c1},y
clc
adc {c2},y
sta {c1},y
lda {c1}+1,y
adc {c2}+1,y
sta {c1}+1,y
lda {c1}+2,y
adc {c2}+2,y
sta {c1}+2,y
lda {c1}+3,y
adc {c2}+3,y
sta {c1}+3,y