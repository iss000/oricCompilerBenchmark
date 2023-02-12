clc
lda {m2}
adc #<{c1}
sta {m1}
lda {m2}
ora #$7f
bmi !+
lda #0
!:
adc #>{c1}
sta {m1}+1