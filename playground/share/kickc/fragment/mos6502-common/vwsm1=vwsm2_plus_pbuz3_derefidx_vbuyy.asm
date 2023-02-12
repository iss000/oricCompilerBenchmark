lda {m2}
clc
adc ({z3}),y
sta {m1}
bcc !+
inc {m2}+1
!: