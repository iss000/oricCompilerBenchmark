sta $fd
lda {m2}
sta $fe
lda {m2}+1
sta $ff
lda ($fe),y
clc
adc $fd
sta {m1}
iny
lda $fd
ora #$7f
bmi !+
lda #0
!:
adc ($fe),y
sta {m1}+1