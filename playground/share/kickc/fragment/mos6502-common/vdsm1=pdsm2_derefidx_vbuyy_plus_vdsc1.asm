lda {m2}
sta $fe
lda {m2}+1
sta $ff
clc
lda ($fe),y
adc #<{c1}
sta {m1}
iny
lda ($fe),y
adc #>{c1}
sta {m1}+1
iny
lda ($fe),y
adc #<{c1}>>$10
sta {m1}+2
iny
lda ($fe),y
adc #>{c1}>>$10
sta {m1}+3