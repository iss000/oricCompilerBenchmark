lda {c1},x
clc
adc #1
sta {c1},y
bne !+
lda {c1}+1,x
adc #0
sta {c1}+1,y
!: