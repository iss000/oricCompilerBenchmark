clc
lda {m2}
adc ({z3}),z
sta {m1}
bcc !+
inc {m2}+1
!: