clc
lda {m2}
adc ({z3}),y
sta {m1}
bcc !+
inc {m1}+1
!: