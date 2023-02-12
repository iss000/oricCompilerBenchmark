clc
lda {m2}
adc {m3}
sta {m1}
lda {m2}+1
adc {m3}+1
sta {m1}+1
lda #0
sta {m1}+3
adc #0
sta {m1}+2

