lda {m2}
clc
adc #<{c1}
sta {m1}
lda {m2}+1
adc #>{c1}
sta {m1}+1
lda {m2}+1
ora #$7f
bmi !+
lda #0
!:
sta $ff
adc #<{c1}>>$10
sta {m1}+2
lda $ff
adc #>{c1}>>$10
sta {m1}+3