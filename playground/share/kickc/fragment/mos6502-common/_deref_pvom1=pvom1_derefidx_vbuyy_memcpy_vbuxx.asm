lda {m1}
sta $fc
clc
sty $fe
adc $fe
sta $fe
lda {m1}+1
sta $fd
adc #00
sta $ff
ldy #0
!:
lda ($fe),y
sta ($fc),y
iny
dex
bne !-