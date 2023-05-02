lda {c2},y
sta $ff
clc
adc {c1},x
sta {c1},x
iny
lda $ff
ora #$7f
bmi !+
lda #0
!:
adc {c1}+1,x
sta {c1}+1,x