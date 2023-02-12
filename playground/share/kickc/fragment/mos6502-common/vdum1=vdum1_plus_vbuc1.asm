lda {m1}
clc
adc #{c1}
sta {m1}
bcc !+
inc {m1}+1
bne !+
inc {m1}+2
bne !+
inc {m1}+3
!: