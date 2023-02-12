clc
sta $ff
adc {m1}
sta {m1}
lda $ff
ora #$7f
bmi !+
lda #0
!:
adc {m1}+1
sta {m1}+1