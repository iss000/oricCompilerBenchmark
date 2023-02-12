clc
lda {c1},y
adc #1
sta {c1},x
bne !+
lda {c1}+1,y
adc #0
sta {c1}+1,x
!: