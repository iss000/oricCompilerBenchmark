lda ({z1}),y
sta $ff
ldy #{c1}
clc
adc ({z1}),y
sta ({z1}),y
iny
lda $ff
ora #$7f
bmi !+
lda #0
!:
adc ({z1}),y
sta ({z1}),y