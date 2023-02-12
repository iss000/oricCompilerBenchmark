lda {m1}
sta $fe
lda {m1}+1
sta $ff
clc
lda ($fe),y
adc #<{c1}
sta ($fe),y
iny
lda ($fe),y
adc #>{c1}
sta ($fe),y
iny
lda ($fe),y
adc #<{c1}>>$10
sta ($fe),y
iny
lda ($fe),y
adc #>{c1}>>$10
sta ($fe),y