sec
lda {m2}
eor #$ff
adc #$0
sta {m1}
lda {m2}+1
eor #$ff
adc #$0
sta {m1}+1
lda {m2}+2
eor #$ff
adc #$0
sta {m1}+2
lda {m2}+3
eor #$ff
adc #$0
sta {m1}+3
