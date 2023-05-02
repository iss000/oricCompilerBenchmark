lda {c1},y
clc
adc {m1}
sta {c1},y
bcc !+
inc {c1}+1,y
!: