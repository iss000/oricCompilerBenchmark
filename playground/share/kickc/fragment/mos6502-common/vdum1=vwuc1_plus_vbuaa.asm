clc
adc #<{c1}
sta {m1}
lda #0
adc #>{c1}
sta {m1}+1
lda #0
adc #0
sta {m1}+2
lda #0
sta {m1}+3

