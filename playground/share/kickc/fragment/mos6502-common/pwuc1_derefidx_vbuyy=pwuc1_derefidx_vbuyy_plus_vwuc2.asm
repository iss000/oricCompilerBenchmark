lda {c1},y
clc
adc #<{c2}
sta {c1},y
lda {c1}+1,y
adc #>{c2}
sta {c1}+1,y
