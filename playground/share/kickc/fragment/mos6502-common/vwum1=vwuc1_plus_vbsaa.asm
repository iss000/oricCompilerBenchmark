sta $ff
clc
adc #<{c1}
sta {m1}
lda $ff
ora #$7f
bmi !+
lda #0
!:
adc #>{c1}
sta {m1}+1