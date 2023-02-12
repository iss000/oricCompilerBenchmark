lda {m2}
clc
adc {m1}
sta {m1}
lda {m2}+1
adc {m1}+1
sta {m1}+1
lda {m2}+1
ora #$7f
bmi !+
lda #0
!:
sta $ff
adc {m1}+2
sta {m1}+2
lda $ff
adc {m1}+3
sta {m1}+3