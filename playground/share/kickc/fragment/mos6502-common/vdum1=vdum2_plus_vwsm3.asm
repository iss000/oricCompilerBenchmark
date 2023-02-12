clc
lda {m3}
adc {m2}
sta {m1}
lda {m3}+1
adc {m2}+1
sta {m1}+1
lda {m3}+1
ora #$7f
bmi !+
lda #0
!:
sta $ff
adc {m2}+2
sta {m1}+2
lda $ff
adc {m2}+3
sta {m1}+3