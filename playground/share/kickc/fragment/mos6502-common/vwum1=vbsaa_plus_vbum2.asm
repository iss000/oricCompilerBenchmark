pha
clc
adc {m2}
sta {m1}
pla
ora #$7f
bmi !+
lda #0
!:
adc #0
sta {m1}+1