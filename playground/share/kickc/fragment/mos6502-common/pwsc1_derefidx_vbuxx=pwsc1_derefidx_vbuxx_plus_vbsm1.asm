lda {c1},x
clc
adc {m1}
sta {c1},x
bcc !+
inc {c1}+1,x
!: