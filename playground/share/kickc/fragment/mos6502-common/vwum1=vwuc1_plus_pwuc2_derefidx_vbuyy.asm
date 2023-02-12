clc
lda #<{c1}
adc {c2},y
sta {m1}
lda #>{c1}
adc {c2}+1,y
sta {m1}+1
