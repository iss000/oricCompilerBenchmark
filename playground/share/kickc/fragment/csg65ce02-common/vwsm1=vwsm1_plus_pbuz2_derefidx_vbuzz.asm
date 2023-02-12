clc
lda {m1}
adc ({z2}),z
sta {m1}
bcc !+
inc {m1}+1
!: