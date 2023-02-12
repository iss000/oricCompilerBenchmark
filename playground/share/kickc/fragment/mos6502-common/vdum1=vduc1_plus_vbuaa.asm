clc
adc #<{c1}
sta {m1}
lda #>{c1}
adc #0
sta {m1}+1
lda #<{c1}>>$10
adc #0
sta {m1}+2
lda #>{c1}>>$10
adc #0
sta {m1}+3
