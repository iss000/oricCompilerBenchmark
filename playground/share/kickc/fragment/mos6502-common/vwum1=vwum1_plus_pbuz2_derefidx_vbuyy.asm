lda {m1}
clc
adc ({z2}),y
sta {m1}
bcc !+
inc {m1}+1
!: