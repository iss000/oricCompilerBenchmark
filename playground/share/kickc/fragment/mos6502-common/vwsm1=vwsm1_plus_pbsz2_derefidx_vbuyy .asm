clc
lda ({z2}),y
adc {m1}
sta {m1}
lda ({z2}),y
ora #$7f
bmi !+
lda #0
!:
adc {m1}+1
sta {m1}+1