lda {m2}
sta $fc
lda {m2}+1
sta $fd
lda {m1}
sta $fe
lda {m1}+1
sta $ff
clc
lda ($fc),y
adc {m3}
sta ($fe),y
iny
lda ($fc),y
adc {m3}+1
sta ($fe),y
iny
lda ($fc),y
adc {m3}+2
sta ($fe),y
iny
lda ($fc),y
adc {m3}+3
sta ($fe),y