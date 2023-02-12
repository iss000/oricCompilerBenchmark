sta $ff
clc
adc {m2}
sta {m1}
lda $ff
ora #$7f
bmi !+
lda #0
!:
adc {m2}+1
sta {m1}+1
