lda {c2},x
sta $ff
clc
adc {c1},y
sta {c1},y
iny
lda $ff
ora #$7f
bmi !+
lda #0
!:
adc {c1}+1,y
sta {c1}+1,y